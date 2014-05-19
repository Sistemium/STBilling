create or replace procedure stb.updateUsers (
    @dbname STRING default null,
    @pageSize int default 200
) begin

    declare @actk STRING;
    
    set @actk= (select accessToken
        from openxml(uac.UOAuthRefreshToken(
            util.getUserOption('stb.refresh_token'),
            util.getUserOption('stb.client_id'),
            util.getUserOption('stb.client_secret')
        ), '/*/*:access-token') with (accessToken STRING '.')
    );
    
    for db as db cursor for
        select db.*, crt.pem, db.id as [@db]
//            , util.timezoneMinutesFromUTC(db.timezone) as tzmntss
//            , dateadd(minute, tzmntss, isnull(syncedUpTo,today()-1)) as @dateB
//            , dateadd(minute, tzmntss, @syncUpTo) as @dateE
            , 1 as @page
            , cast('' as xml) as @partialResponse
            , cast('' as xml) as @response,
            string( db.hrefGet
                , 'st.users.xml'
//                , '@dateB=', http_encode(left(@dateB,16))
//                , '&@dateE=', http_encode(left(@dateE,16))
                , '?page-size:=', @pageSize, '&page-number:='
            ) as @url
        from stb.db join stb.crt
        where (db.name = @dbname or @dbname is null)
//            and @dateB<@dateE
    do
        
        WHILE (@page > 0) LOOP
            
            message 'stb.updateUsers has requested url: ', @url, @page
                to client
            ;
            
            select util.httpsGet (
                string (@url, @page)
                , string ('authorization:', @actk)
                , string ('cert=', pem)
            ) into @partialResponse;
            
            message 'stb.updateUsers got page ', @page
                to client
            ;
            
            set @page = util.nextPageFromRestResponse(@partialResponse);
            
            select xmlconcat (@response, xmlagg(responseData))
                into @response
                from openxml (@partialResponse, '/*/*') with (
                    responseData XML '@mp:xmltext'
                )
            ;
            
        END LOOP;
        
        merge into stb.DbUserDate
            using with auto name (
                select
                    [@db] as db, today() as [date], *
                from openxml (xmlelement('r',@response), '/*/*') with (
                    [username] string '*[@name="name"]',
                    [legalName] string '*[@name="org"]',
                    [name] string '*[@name="fullname"]'
                ) where
                    [username] is not null
            ) as dud
            on dud.username = DbUserDate.username
                and dud.[date] = DbUserDate.[date]
                and dud.[db] = DbUserDate.db
            when not matched then insert
            when matched then skip
        ;
        
        message 'stb.updateUsers merged rows ', @@rowcount, ' from db "', name, '"'
            to client
        ;
        
//        update stb.db set
//            syncedUpTo = @syncUpTo
//        where db.id = db;
        
    end for;

end;