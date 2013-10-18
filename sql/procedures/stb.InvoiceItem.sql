create or replace procedure stb.invoiceItemByDates (
    @dateB date default dateadd(day, 1-day(today()), today()),
    @dateE date default today()
) begin

    select
        c.id as [contract],
        count(distinct username) as [volume],
        1 as [service]
    from stb.usage join stb.db on db = usage.db
        join stb.Contract c
            on usage.[date] between c.dateB and c.dateE
                and c.org = db.org
    where usage.[date] between @dateB and @dateE
    group by c.id

end;