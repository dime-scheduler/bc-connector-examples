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
        DimeDSConnectorSetup.Get();
        DimeDSSetup.Get();

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
        DSWebServMgt.AddParameter('ResourceType', 'Salesperson');

        DSWebServMgt.AddParameter('TeamCode', '');
        DSWebServMgt.AddParameter('TeamName', '');
        DSWebServMgt.AddParameter('TeamType', '');
        // Numeric value to sort Teams instead of on Team Code
        DSWebServMgt.AddParameter('TeamSort', Format(0, 0, 9));
        DSWebServMgt.AddParameter('TeamMemberType', '');
        // numeric value to sort Members within a Team instead of on Team Member Type
        DSWebServMgt.AddParameter('TeamMemberSort', Format(0, 0, 9));

        // Field that affects the layout/view of a Resource
        DSWebServMgt.AddParameter('DisplayName', '');

        // Setting DoNotShow to TRUE hides the Resource from all users
        DSWebServMgt.AddParameter('DoNotShow', DSWebServMgt.HandleBool((Rec.Blocked)));

        DSWebServMgt.AddParameter('Email', Rec."E-Mail");
        DSWebServMgt.AddParameter('Phone', Rec."Phone No.");
        DSWebServMgt.AddParameter('MobilePhone', '');
        DSWebServMgt.AddParameter('FieldServiceEmail', Rec."E-Mail");
        DSWebServMgt.AddParameter('HomeAddress', '');
        DSWebServMgt.AddParameter('HomePostcode', '');
        DSWebServMgt.AddParameter('HomeCity', '');
        DSWebServMgt.AddParameter('HomeCounty', '');
        DSWebServMgt.AddParameter('HomeState', '');
        DSWebServMgt.AddParameter('HomeCountry', '');
        DSWebServMgt.AddParameter('HomeEmail', '');
        DSWebServMgt.AddParameter('HomePhone', '');
        DSWebServMgt.AddParameter('HomeRegion', '');
        DSWebServMgt.AddParameter('PersonalEmail', '');
        DSWebServMgt.AddParameter('InServiceFrom', '');
        DSWebServMgt.AddParameter('InServiceTill', '');

        DSWebServMgt.AddParameter('FreeText1', '');
        DSWebServMgt.AddParameter('FreeText2', '');
        DSWebServMgt.AddParameter('FreeText3', '');
        DSWebServMgt.AddParameter('FreeText4', '');
        DSWebServMgt.AddParameter('FreeText5', '');
        DSWebServMgt.AddParameter('FreeText6', '');
        DSWebServMgt.AddParameter('FreeText7', '');
        DSWebServMgt.AddParameter('FreeText8', '');
        DSWebServMgt.AddParameter('FreeText9', '');
        DSWebServMgt.AddParameter('FreeText10', '');
        DSWebServMgt.AddParameter('FreeText11', '');
        DSWebServMgt.AddParameter('FreeText12', '');
        DSWebServMgt.AddParameter('FreeText13', '');
        DSWebServMgt.AddParameter('FreeText14', '');
        DSWebServMgt.AddParameter('FreeText15', '');
        DSWebServMgt.AddParameter('FreeText16', '');
        DSWebServMgt.AddParameter('FreeText17', '');
        DSWebServMgt.AddParameter('FreeText18', '');
        DSWebServMgt.AddParameter('FreeText19', '');
        DSWebServMgt.AddParameter('FreeText20', '');
        DSWebServMgt.AddParameter('FreeDecimal1', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal2', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal3', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal4', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal5', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal6', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal7', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal8', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal9', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDecimal10', Format(0, 0, 9));
        DSWebServMgt.AddParameter('FreeDate1', DSWebServMgt.HandleDateTime(0DT));
        DSWebServMgt.AddParameter('FreeDate2', DSWebServMgt.HandleDateTime(0DT));
        DSWebServMgt.AddParameter('FreeDate3', DSWebServMgt.HandleDateTime(0DT));
        DSWebServMgt.AddParameter('FreeDate4', DSWebServMgt.HandleDateTime(0DT));
        DSWebServMgt.AddParameter('FreeDate5', DSWebServMgt.HandleDateTime(0DT));
        DSWebServMgt.AddParameter('FreeBit1', DSWebServMgt.HandleBool(false));
        DSWebServMgt.AddParameter('FreeBit2', DSWebServMgt.HandleBool(false));
        DSWebServMgt.AddParameter('FreeBit3', DSWebServMgt.HandleBool(false));
        DSWebServMgt.AddParameter('FreeBit4', DSWebServMgt.HandleBool(false));
        DSWebServMgt.AddParameter('FreeBit5', DSWebServMgt.HandleBool(false));

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

