create or replace procedure stb.AgentStatsByDate (
    @dateStart date default dateadd (day, -day(today()) + 1, today()),
    @dateEnd date default today()
) begin

    select u.[date], list(distinct a.name, ', ') agentNames, sum(u.cnt) cnt
        from stb.usage u
        join stb.agent a
        on a.username = u.username
    where u.[date] between @dateStart and @dateEnd
    group by u.[date]
    order by 1

end;