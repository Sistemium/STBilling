insert into stb.Org on existing update with auto name select
    1 as id, 'Unact' as name
;

insert into stb.Crt with auto name select
    1 as id, 'system.unact.ru' as name,
    '-----BEGIN CERTIFICATE-----
MIIEoDCCA4igAwIBAgIQIkGfnCsSTDy2Pgslos4j+TANBgkqhkiG9w0BAQUFADA8
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMVGhhd3RlLCBJbmMuMRYwFAYDVQQDEw1U
aGF3dGUgU1NMIENBMB4XDTE0MDkxMjAwMDAwMFoXDTE4MTAxMTIzNTk1OVowcDEL
MAkGA1UEBhMCUlUxDzANBgNVBAgTBk1vc2NvdzEPMA0GA1UEBxQGTW9zY293MRgw
FgYDVQQKFA9VTkFDVCB0cmFkZSBPT08xCzAJBgNVBAsUAklUMRgwFgYDVQQDFA9z
eXN0ZW0udW5hY3QucnUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9
zUF2nu84Lq/YO3pC88vWdF8jNhEtxk7ks22RThTJCO3vJAogMYA5Gf7LnkCqwv6P
QYN3lLKpFzBNxjRbwEQl4BS3HdBJO+MQuMA83+ckvlZ6oi9Gjp2+oE732S1Kz502
OrssIZ5ZgN2VaUb07hOtcA4on1Fk7hXi5i7gw9uhC4kx7JdknNeNheLOiHguOJsL
P989191Pgav8XkyA5vRdWN452keI6f5oUM2sqfu0Y/w8reLbaDR1PTbN9M/LkWhR
m++5xfZQY8I9W3yCygGwo/RaUQGof8RrJnIKp0k7tmhaZEvysa1ZQigiNKNXahRJ
LLAbvMjA6+0kzJETV4opAgMBAAGjggFoMIIBZDAaBgNVHREEEzARgg9zeXN0ZW0u
dW5hY3QucnUwCQYDVR0TBAIwADBlBgNVHSAEXjBcMFoGCmCGSAGG+EUBBzYwTDAj
BggrBgEFBQcCARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIw
GRYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9ycGEwDgYDVR0PAQH/BAQDAgWgMB8GA1Ud
IwQYMBaAFKeig7s0RUA9/NUwTxK5PqEBn/bbMCsGA1UdHwQkMCIwIKAeoByGGmh0
dHA6Ly90Yi5zeW1jYi5jb20vdGIuY3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggr
BgEFBQcDAjBXBggrBgEFBQcBAQRLMEkwHwYIKwYBBQUHMAGGE2h0dHA6Ly90Yi5z
eW1jZC5jb20wJgYIKwYBBQUHMAKGGmh0dHA6Ly90Yi5zeW1jYi5jb20vdGIuY3J0
MA0GCSqGSIb3DQEBBQUAA4IBAQCXl3zj5XGieQDmoFQgGazbZxLSemx5S+kqSk94
haMnn9ciZkdw3HXf7FJM61oazMf48YyUvfZxqRz0hNs01bc+L9pRoLUqiDNpfy2L
J1G1fEq3+KJsRwHosmNUULB+KAyI70lnY2Jj9QlSvuIS8zry5rcAP0WCUwyudQ9m
abFyqB1A9sZ/xK4b780eUjGqRSNkFlU23xw5LkfdV5RTaLpwcklSApTT+HCi6Kps
TbinZQc/bqtLDkUWgkdm567nd2gjnwNQao9E8kmGfSuH7y7EWh2jhxcWS7qu+eZB
MTCILY2XN9Elf6W0gaOkx1JQkG6TxSPP3nVJVNVUXSBWKDJT
-----END CERTIFICATE-----
' as pem;

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
