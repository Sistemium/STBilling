create or replace procedure stb.ContractByPeriod (
    @period IDREF
) begin

    select * from stb.Contract
    where exists (
        select * from stb.period
        where dateB <= Contract.dateE
            and dateE >= Contract.dateB
            and id = @period
    )

end;