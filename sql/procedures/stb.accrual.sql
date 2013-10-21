create or replace procedure stb.accrualByDates (
    @dateB date default dateadd(day, 1-day(today()), today()),
    @dateE date default today()
) begin

    select
        a.id,
        a.[contract],
        a.[service],
        a.[volume],
        a.[description],
        a.[href],
        a.[date],
        a.[acceptanceDate],
        if a.[acceptanceDate] is null
            then 'open'
            else 'closed'
        endif [status]
    from stb.Accrual a 
    where a.[acceptanceDate] between @dateB and @dateE
        or (a.[acceptanceDate] is null and a.[date] <= @dateE
            and not exists (select * from stb.period where dateB>@dateE)
        )
    
end;

create or replace procedure stb.usageByDates (
    @dateB date default dateadd(day, 1-day(today()), today()),
    @dateE date default today()
) begin

    select
        c.id as [contract],
        [username],
        list (distinct program) [program],
        list (distinct path) [path],
        sum(cnt) [cnt]
    from stb.Usage
        join stb.Db
            on Db.id = Usage.db
        join stb.Contract c
            on c.org = Db.org and Usage.[date] between c.dateB and c.dateE
    where Usage.[date] between @dateB and @dateE
        and username is not null
    group by [contract], [username]
    
end;