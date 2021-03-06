create or replace procedure stb.UserStats (
    @legalContract IDREF,
    @dateStart date default today(),
    @dateEnd date default today()
) begin

    select
        (select max(dub.name)
            from stb.DbUserDate dub
                join stb.legalEntity le
                    on le.name = dub.legalName
                join stb.legalContract lc
                    on lc.legalEntity = le.id and (
                        lc.dateB<=@dateEnd
                        and lc.dateE>=@dateStart
                    )
            where dub.username = Usage.username
                and dub.[date] between @dateStart and @dateEnd
                and lc.id = @legalContract
            group by dub.username
        ) as name,
        
        sum(cnt) [operations-count],
        count(distinct usage.[date]) [dates-count],
        list(distinct Usage.program) [programs]
        
    from stb.Usage
        join stb.Db
            on Db.id = Usage.db
        join stb.Contract c
            on c.org = Db.org and Usage.[date] between c.dateB and c.dateE
        left join stb.[User] u on u.name = Usage.username
        
        
    where Usage.[date] between @dateStart and @dateEnd
        and u.price is null
        and Usage.path not like '%~%'
        and exists (
            select * from stb.ProgramLicense pl
            where pl.name = usage.program
                and pl.legalContract = @legalContract
                and pl.dateB<=@dateEnd
                and pl.dateE>=@dateStart
                and Usage.[date] between pl.dateB and pl.dateE
                and term = 'users'
        )
    group by Usage.username
    having name is not null
        and [operations-count] >= 10
        and [dates-count] > 1

end;