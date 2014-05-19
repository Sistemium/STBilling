create or replace procedure st.users ()
begin
    
    select
        a.name as [id],
        a.name,
        case a.org_id
            when 2  then 'Unact-union'
            when 4  then 'Tratta-center'
            when 22 then 'Baros'
            when 24 then 'Megaport'
            when 27 then 'Unact-trade'
        end [org],
        string(
            p.lname, ' ',
            p.fname, ' ',
            p.mname
        ) as fullname
    from (
        select id,name,
            (select person from dbo.agents where loginname = agent.name) as a_person,
            (select int_org_id
                from dbo.emp_contract er 
                where person_id = a_person and ddatee is null
            ) org_id
        from xmlgate.agent 
    ) a join dbo.person p on p.person_id = a.a_person
    where org is not null
    
end;