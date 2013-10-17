create or replace procedure stb.accrualByDates (
    @dateB date default dateadd(day, 1-day(today()), today()),
    @dateE date default today()
) begin

    select
        db.org, count(distinct username) volume, 1 as service
    from stb.usage join stb.db
    where
        usage.[date] between @dateB and @dateE
    group by db.org

end;