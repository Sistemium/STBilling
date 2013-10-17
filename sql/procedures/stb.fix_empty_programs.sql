create or replace procedure stb.fix_empty_programs ()
begin

    update stb.usage set program = 'iorders'
        where path in ('/b/XML/','/k/XML/','/a/XML/','/r/XML/')
        and program is null
    ;
    update stb.usage set program = 'expeditioning'
        where path in ('/XML2/')
        and program is null
    ;

end;