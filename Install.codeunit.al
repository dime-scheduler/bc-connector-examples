codeunit 2088007 "DS Install Demo"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitializeDSSourceTypes();
    end;

    local procedure InitializeDSSourceTypes()
    var
        DSSourceType: Record "Dime DS Source Type";
        DimeDSSetup: Record "Dime DS Setup";
    begin
        // Check if setup exist
        if not DimeDSSetup.Get() then
            exit;

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
            DSSourceType."Processing Codeunit No." := Codeunit::"DS Handle Opportunity Demo";
            DSSourceType.Insert();
        end;
    end;
}