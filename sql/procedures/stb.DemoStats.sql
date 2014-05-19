create or replace procedure stb.DemoStats (
    @legalContract IDREF,
    @dateStart date default today(),
    @dateEnd date default today()
) begin

select [date], sum ([operations-count]) as [operations-count],
        list (distinct name, ', ' order by name) as names, list (distinct [program]) as [programs]
from (
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
        
        Usage.[date],
        Usage.program,
        sum(cnt) [operations-count]
        
    from stb.Usage
        join stb.Db
            on Db.id = Usage.db
        join stb.Contract c
            on c.org = Db.org and Usage.[date] between c.dateB and c.dateE
        
    where Usage.[date] between @dateStart and @dateEnd
        and Usage.path not like '%~%'
        and exists (
            select * from stb.ProgramLicense pl
            where pl.name = usage.program
                and pl.legalContract = @legalContract
                and pl.dateB<=@dateEnd
                and pl.dateE>=@dateStart
                and Usage.[date] between pl.dateB and pl.dateE
                and term = 'demo'
        )
        
    group by
        Usage.username,
        usage.[date],
        Usage.program
) as t

group by [date]

end;