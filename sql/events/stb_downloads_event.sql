sa_make_object 'event', 'stb_downloads';

drop event stb_downloads;

create event stb_downloads
handler begin

    declare @now timestamp;
    
    set @now = now();

    IF
        EVENT_PARAMETER( 'NumActive' ) > 1
        or DB_NAME() <> 'STCentral'
    THEN
        return;
    END IF;
    
    message 'stb_downloads event start';

    call stb.updateStats();
    
    for r as r cursor for
        select
            Db.name, count(*) as cnt
        from stb.Db join stb.Usage
        where Usage.ts > @now
        group by Db.name
    do
        message 'stb_downloads got ', cnt, ' records from "', name, '" db';
    end for;
    
    call stb.fix_empty_programs();

    message 'stb_downloads event end';

end;

alter event stb_downloads add SCHEDULE hourly START TIME '0:15' EVERY 1 HOURS;

// trigger event stb_downloads