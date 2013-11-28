create domain PRICE decimal (18,2) not null;

ch.defineProperties
    'date,date'
    + ':syncedUpTo,datetime'
    + ':hour,int'
    + ':username,string'
    + ':program,string'
    + ':path,string'
    + ':name,string'
    + ':legalName,string'
    + ':cnt,int'
    + ':pem,string'
    + ':timezone,string'
    + ':hrefGet,string'
;

ch.defineProperties
    'dateB,date'
    + ':dateE,date'
    + ':ndoc,string'
    + ':price,PRICE'
;

ch.defineProperties
    'description,text'
    + ':volume,int'
    + ':href,string'
    + ':acceptanceDate,date'
;
