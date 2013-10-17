ch.defineEntity 'Crt',
    @properties = 'name:pem',
    @roles = ''
;

ch.defineEntity 'Org',
    @properties = 'name',
    @roles = ''
;

ch.defineEntity 'Db',
    @properties = 'name:hrefGet:timezone:syncedUpTo',
    @roles = 'Org:Crt'
;

ch.defineEntity 'Usage',
    @properties = 'date:hour:username:program:path:cnt',
    @roles = 'Db'
;

drop table stb.Usage;
drop table stb.Db;

ch.createTable 'Crt', 'stb', 0, 1;
ch.createTable 'Org', 'stb', 0, 1;
ch.createTable 'Db', 'stb', 0;
ch.createTable 'Usage', 'stb', 0;
