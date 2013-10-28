create or replace procedure stb.invoiceItemByDates (
    @dateB date default dateadd(day, 1-day(today()), today()),
    @dateE date default today()
) begin

    select
        [contract],
        1 as [service],
        count(distinct username) as [volume]
    from stb.UsageByDates (@dateB,@dateE)
    where [datesCnt] > 1 and cnt >= 10
    group by [contract], [service]
    
    union all select
        [contract],
        [service],
        sum(volume) as [volume]
    from stb.AccrualByDates (@dateB,@dateE)
    group by [contract], [service]

end;