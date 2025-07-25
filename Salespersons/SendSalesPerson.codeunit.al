codeunit 2088003 "DS Send Sales Person Demo"
{
    TableNo = "Salesperson/Purchaser";

    trigger OnRun()
    var
        DimeDSSetup: Record "Dime DS Setup";
        DimeDSConnectorSetup: Record "Dime DS Connector Setup";
        DimeDSDocFilterValueMgt: Codeunit "Dime DS Doc. Filter Value Mgt.";
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
        RecRef: RecordRef;
    begin
        // Ensure setup records exist
        if not DimeDSConnectorSetup.Get() then
            exit;

        if not DimeDSSetup.Get() then
            exit;

        // Transfer the Filter Values for the Resource - uses the DS Doc. Filter Value Sources setup
        RecRef.GetTable(Rec);
        RecRef.SetRecFilter();
        DimeDSDocFilterValueMgt.TransferDocFilterValues(RecRef);

        DSWebServMgt.InitParameters();

        // Mandatory fields
        DSWebServMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
        DSWebServMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::"Salesperson/Purchaser"));
        DSWebServMgt.AddParameter('ResourceNo', Rec.Code);

        DSWebServMgt.AddParameter('ResourceName', Rec.Name);
        DSWebServMgt.AddParameter('DisplayName', Rec.Name);
        DSWebServMgt.AddParameter('ResourceType', 'Salesperson');

        // Setting DoNotShow to TRUE hides the Resource from all users
        DSWebServMgt.AddParameter('DoNotShow', DSWebServMgt.HandleBool((Rec.Blocked)));

        DSWebServMgt.AddParameter('Email', Rec."E-Mail");
        DSWebServMgt.AddParameter('Phone', Rec."Phone No.");
        DSWebServMgt.AddParameter('MobilePhone', Rec."Phone No.");
        DSWebServMgt.AddParameter('FieldServiceEmail', Rec."E-Mail");

        // Sending Links with the Resource - up to 3 are available in mboc_upsertResource, use mboc_upsertResourceUrl for more
        RecRef.GetTable(Rec);
        DSWebServMgt.AddParameter('url1', DimeDSDimeSchedulerMgt.GeneratePageUrl(RecRef, 5116));
        DSWebServMgt.AddParameter('urldesc1', 'Salesperson Card');

        DSWebServMgt.CallDimeSchedulerWS('mboc_upsertResource');
    end;

    var
        DSWebServMgt: Codeunit "Dime DS Web Service Management";

    procedure SyncSalespersons(var Salesperson: Record "Salesperson/Purchaser")
    begin
        if Salesperson.FindSet() then
            repeat
                CODEUNIT.Run(CODEUNIT::"DS Send Sales Person Demo", Salesperson);
            until Salesperson.Next() = 0;
    end;
}

