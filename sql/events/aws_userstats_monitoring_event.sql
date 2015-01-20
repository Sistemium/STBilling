sa_make_object 'event', 'aws_userstats_monitoring_event';

drop event aws_userstats_monitoring_event;

create event aws_userstats_monitoring_event
handler begin

    declare @date date;
    declare @hour int;
    declare @now timestamp;
    
    if EVENT_PARAMETER('NumActive') <> '1' then 
        return;
    end if;
 
    set @now = dateadd(hour, -1, now());
    set @date = date(@now);
    set @hour = hour(@now);
    
    for c as c cursor for
        
        select
            count(*) as [Users Count],
            @now as [Timestamp],
            aws.putMetricData (
                'Users Count',
                [Users Count],
                [Timestamp]
            ) as [putCountResponse]
        from (
            select
                c.id as [contract],
                [username],
                list (distinct program) [program],
                sum(cnt) [cnt]
            from stb.Usage
                join stb.Db
                    on Db.id = Usage.db
                join stb.Contract c
                    on c.org = Db.org and Usage.[date] between c.dateB and c.dateE
                left join stb.[User] u on u.name = Usage.username
            where Usage.[date] = @date and  Usage.[hour] = @hour
                and Usage.username is not null
                and u.price is null
                and Usage.path not like '%~%'
            group by [contract], [username]
        ) as t
        
    do message
        
        current database, '.aws_userstats_monitoring_event',
        ' put: ', [Users Count],
        ' for ts: ''', [Timestamp], '''',
        ' putCountResponse: ', [putCountResponse]
        
    --debug only
    end for;
    
end;

alter event aws_userstats_monitoring_event add SCHEDULE heartbeat
    start time '00:01:00'
    every 1 hours
;
