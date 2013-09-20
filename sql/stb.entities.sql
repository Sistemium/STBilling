ch.defineProperties
    'date,date'
    + ':syncedUpTo,datetime'
    + ':hour,int'
    + ':username,string'
    + ':program,string'
    + ':path,string'
    + ':name,string'
    + ':cnt,int'
    + ':pem,string'
    + ':timezone,string'
    + ':hrefGet,string'
;

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

insert into stb.Org on existing update with auto name select
    1 as id, 'Unact' as name
;

insert into stb.Crt with auto name select
    1 as id, 'system.unact.ru' as name,
    '-----BEGIN CERTIFICATE-----
MIIDzzCCAregAwIBAgIQPjouu6ST0E6blVQ+skr2jzANBgkqhkiG9w0BAQUFADA8
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMVGhhd3RlLCBJbmMuMRYwFAYDVQQDEw1U
aGF3dGUgU1NMIENBMB4XDTExMDgyNDAwMDAwMFoXDTE0MDkyMjIzNTk1OVowaDEL
MAkGA1UEBhMCUlUxCzAJBgNVBAgTAlJVMQ8wDQYDVQQHFAZNb3Njb3cxFDASBgNV
BAoUC1VOQUNUIFRyYWRlMQswCQYDVQQLFAJJVDEYMBYGA1UEAxQPc3lzdGVtLnVu
YWN0LnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnxeCD9+yb+7/
8hYZkt0cxOAOYUblkRcfqVGHCPd1jwu2o4GU5Gp6FNWTwBlXjxyQBCyHLxw6FBV6
Iyvm+O066h71D44oEAOobKOW9YlKdbVyy/0/t4GruVYCPSP4ZxtgUEyXnX6FYoPM
jomnkSIaVYArJJ0IM8CqhTyOBlSQKm/2H7/CGWddv7WjZ5AKSmpLB5Mm0TbowU8/
W3SVJjt9yDXTeriqV2rDS44ssWc2jvbwwxXYfgKyN/tKxyeNJdnnNafwQ9c58low
Vuti2kS7Yfp+4Kjx+d/VAsHYoCcgM2gZxdU9FjJnPR2RUDcXf8jYO9lqXXLT311K
JZEvjnS68QIDAQABo4GgMIGdMAwGA1UdEwEB/wQCMAAwOgYDVR0fBDMwMTAvoC2g
K4YpaHR0cDovL3N2ci1vdi1jcmwudGhhd3RlLmNvbS9UaGF3dGVPVi5jcmwwHQYD
VR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMDIGCCsGAQUFBwEBBCYwJDAiBggr
BgEFBQcwAYYWaHR0cDovL29jc3AudGhhd3RlLmNvbTANBgkqhkiG9w0BAQUFAAOC
AQEAfBRKFpPiHK+VE7E4q2cDHN020C1mHk/FHGB2TkKwNTG4OWERj3csDQMABFSm
adI/S7m7D/X3CH0kIzYmVSyGW+gFu0xk/s1ccZFFyKbeZZizfye/HHmfPsjZ/5qt
JHMq9N7oVFBaHpanNthD3LrPH6NYVvd/g+ht4RyCT29+8Gl2Kes5W/8THM6r+CYV
ETF6y6YBtVUmelMs/5feTOn0NTAJsfby0hm/jIitkjUYSzjDH/CcXZJ7gRTSpBRx
hr6oUNdF1n0flKlw71UXFbXv0pLWdTujJrcjQuZkVAyq7ud8wjTTJSzEoPOwcthf
zbgqrFSg/NiIG27wTUg59RTQfQ==
-----END CERTIFICATE-----' as pem;

insert into stb.Db on existing update with auto name select
    1 as id, 1 as org
    , 'rc_unact' as name
    , 'MSK' as timezone
    , 'https://system.unact.ru/iproxy/rest/' as hrefGet
    , crt.id as crt
from stb.crt where crt.name='system.unact.ru';

insert into stb.Db on existing update with auto name select
    2 as id, 1 as org
    , 'op' as name
    , 'MSK' as timezone
    , 'https://system.unact.ru/iproxy/rest/op/' as hrefGet
    , crt.id as crt
from stb.crt where crt.name='system.unact.ru';