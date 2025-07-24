codeunit 2088007 "DS Install Demo"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        Message('Upgrade per company');
        InitializeDSSourceTypes();
    end;

    local procedure InitializeDSSourceTypes()
    var
        DSSourceType: Record "Dime DS Source Type";
        DimeDSSetup: Record "Dime DS Setup";
    begin
        // Initialize SalesPerson source type
        if not DSSourceType.Get(DATABASE::"Salesperson/Purchaser") then begin
            DSSourceType.Init();
            DSSourceType."Table No." := DATABASE::"Salesperson/Purchaser";
            DSSourceType."Source Type" := 'REP';
            DSSourceType.Insert();
        end;

        // Initialize Opportunity source type
        if not DSSourceType.Get(DATABASE::Opportunity) then begin
            DSSourceType.Init();
            DSSourceType."Table No." := DATABASE::Opportunity;
            DSSourceType."Source Type" := 'OPP';
            DSSourceType."Processing Codeunit No." := 2088002;
            DSSourceType.Insert();
        end;

        // Get the current setup
        if not DimeDSSetup.Get() then
            DimeDSSetup.Init();
    end;
}