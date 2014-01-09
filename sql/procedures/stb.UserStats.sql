create or replace procedure stb.UserStats (
    @dateStart date default today(),
    @dateEnd date default today()
) begin

    select
            a.name as name,
            sum(cnt) [operations-count],
            count(distinct usage.[date]) [dates-count]
        from stb.Usage
            join stb.Db
                on Db.id = Usage.db
            join stb.Contract c
                on c.org = Db.org and Usage.[date] between c.dateB and c.dateE
            left join stb.[User] u on u.name = Usage.username
            left join stb.agent a
            on a.username = usage.username
        where month([date]) = 12
            and Usage.username is not null
            and u.price is null
            and Usage.path not like '%~%'
            and usage.program = 'mp-terminal-service'
        group by name
    having name is not null

end;