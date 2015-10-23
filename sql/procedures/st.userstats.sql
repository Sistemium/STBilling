create or replace procedure st.userStats (
    @dateB datetime default today() - 1,
    @dateE datetime default today()
) begin

    select string([date],[hour],1) as id, date(cts) [date], hour(cts) [hour],
            username, program, path, count(*) cnt
        from xmlgate.query
        where cts >= @dateB and cts < @dateE
        group by username, [date], [hour], path, program

    union all

    select string([date],[hour],2) as id, date(log.cts) [date], hour(log.cts) [hour],
            a.code as username, 'terminal-tracker' as program, 'api' as path,
            count(*) cnt
        from ch.log join uac.account a on a.id = log.account
        where log.cts >= @dateB and log.cts < @dateE
            and log.response like '%iAgentTask%'
        group by username, [date], [hour], path, program

    union all

    select string([date],[hour],3) as id, date(log.cts) [date], hour(log.cts) [hour],
            a.code as username, 'terminal-tracker' as program, 'api' as path,
            count(*) cnt
        from ar.log
            join uac.token t on t.token = log.code
            join uac.account a on a.id = t.account
        where log.cts >= @dateB and log.cts < @dateE
            and log.url = 'news/megaport'
        group by username, [date], [hour], path, program
    ;

end;
