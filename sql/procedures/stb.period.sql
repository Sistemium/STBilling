create or replace procedure stb.periodByOrg (
    @org IDREF
) begin

    select *
    from stb.period

end;

create or replace view stb.period
as select
        string(2000 + y.row_num, if m.row_num < 10 then '0' endif, m.row_num) as id,
        cast(id+'01' as date) as dateB,
        cast(dateadd(day, -1, dateadd(month, 1, dateB)) as date) as dateE
    from rowgenerator y
        join rowgenerator m
        on m.row_num between 1 and 12
    where y.row_num between 13 and 15
    and dateb between '20130701' and today()
;
