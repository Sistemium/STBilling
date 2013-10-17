create or replace procedure st.userStats (
    @dateB datetime default today() - 1
    @dateE datetime default today()
) begin

    select string([date],[hour]) as id, date(cts) [date], hour(cts) [hour], username, program, path, count(*) cnt
        from xmlgate.query
        where cts >= @dateB and cts < @dateE
        group by username, [date], [hour], path, program
    ;
    
end;