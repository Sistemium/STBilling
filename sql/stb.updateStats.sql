create or replace procedure stb.updateStats (
    @dbname STRING default null,
    @syncUpTo datetime default datetime (left(dateadd(hour,-1,now()),13)+':00')
) begin

    declare @actk STRING;
    declare @url STRING;
    
    set @actk= (select accessToken
        from openxml(uac.UOAuthRefreshToken(
            util.getUserOption('stb.refresh_token'),
            util.getUserOption('stb.client_id'),
            util.getUserOption('stb.client_secret')
        ), '/*/*:access-token') with (accessToken STRING '.')
    );
    
    for db as db cursor for
        select db.*, crt.pem, db.id as db
            , util.timezoneMinutesFromUTC(db.timezone) as tzmntss
            , dateadd(minute, tzmntss, isnull(syncedUpTo,today()-1)) as @dateB
            , dateadd(minute, tzmntss, @syncUpTo) as @dateE
            , 1 as @page
            , cast('' as xml) as @partialResponse
            , cast('' as xml) as @response
        from stb.db join stb.crt
        where (db.name = @dbname or @dbname is null)
            and @dateB<@dateE
    do
        
        WHILE (@page > 0) LOOP
            
            set @url = string( hrefGet
                    , 'st.userstats.xml/'
                    , '@dateB=', http_encode(left(@dateB,16))
                    , '&@dateE=', http_encode(left(@dateE,16))
                    , '?page-size:=500&page-number:=', @page
                )
            ;
            
            message 'stb.updateStats has requested url: ', @url
                to client
            ;
            
            select util.httpsGet (
                @url,
                string ('authorization:', @actk),
                string ('cert=', pem)
            ) into @partialResponse;
            
            message 'stb.updateStats got page ', @page
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
        
        insert into stb.Usage with auto name
        select db, * from openxml (xmlelement('r',@response), '/*/*') with (
            [date] date '*[@name="date"]',
            [hour] int '*[@name="hour"]',
            [username] string '*[@name="username"]',
            [program] string '*[@name="program"]',
            [path] string '*[@name="path"]',
            [cnt] int '*[@name="cnt"]'
        );
        
        message 'stb.updateStats got rows ', @@rowcount, ' from db "', name, '"'
            to client
        ;
        
        update stb.db set
            syncedUpTo = @syncUpTo
        where db.id = db;
        
    end for;

end;