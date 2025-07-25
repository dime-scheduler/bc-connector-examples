codeunit 2088000 "DS Send Opportunity Demo"
{
    TableNo = Opportunity;

    trigger OnRun()
    var
        Contact: Record Contact;
        OpportunityStages: Record "Opportunity Entry";
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
        DimeDSConnectorSetup: Record "Dime DS Connector Setup";
        DimeDSSetup: Record "Dime DS Setup";
        DSWebservMgt: Codeunit "Dime DS Web Service Management";
    begin
        // Ensure setup records exist
        if not DimeDSConnectorSetup.Get() then
            exit;

        if not DimeDSSetup.Get() then
            exit;

        EnsureDSSourceTypes();

        if not Contact.get(Rec."Contact No.") then
            exit;

        DSWebservMgt.InitParameters();

        // Mandatory fields
        DSWebservMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
        DSWebservMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::Opportunity));
        DSWebservMgt.AddParameter('JobNo', Rec."No.");
        DSWebservMgt.AddParameter('ShortDescription', Rec.Description);
        DSWebservMgt.AddParameter('Description', Rec.Description);

        DSWebservMgt.AddParameter('Type', Rec."Sales Cycle Code");
        DSWebservMgt.AddParameter('CustomerNo', Rec."Contact No.");
        DSWebservMgt.AddParameter('CustomerName', Rec."Contact Name");
        DSWebservMgt.AddParameter('CustomerAddress', Contact.Address + ', ' + Contact."Address 2" + ', ' + Contact."Post Code" + ', ' + Contact.City);
        DSWebservMgt.AddParameter('CustomerPhone', Contact."Phone No.");
        DSWebservMgt.AddParameter('CustomerEmail', Contact."E-Mail");
        DSWebservMgt.AddParameter('ContactNo', Contact."No.");
        DSWebservMgt.AddParameter('ContactName', Contact.Name);

        // The address shown on the map in Dime.Scheduler
        DSWebservMgt.AddParameter('SiteAddress', Contact.Address + ', ' + Contact."Address 2" + ', ' + Contact."Post Code" + ', ' + Contact.City);

        DSWebservMgt.AddParameter('SitePostcode', Contact."Post Code");
        DSWebservMgt.AddParameter('SiteCity', Contact."City");
        DSWebservMgt.AddParameter('SiteCounty', Contact."County");
        DSWebservMgt.AddParameter('SiteCountry', DimeDSDimeSchedulerMgt.GetCountryCode(Contact."Country/Region Code"));
        DSWebServMgt.AddParameter('CreationDateTime', DSWebServMgt.HandleDateTime(CREATEDATETIME(Rec."Creation Date", 0T)));
        DSWebservMgt.AddParameter('Creator', CopyStr(UserId(), 1, 1024));

        DSWebservMgt.AddParameter('FreeText1', format(Rec.Status));

        // Call the Dime.Scheduler web service will insert or update the Job
        DSWebservMgt.CallDimeSchedulerWS('mboc_upsertJob');

        // Check if opportunity header should be sent as task
        if Rec."DS Send Opportunity Header" then
            this.SendOpportunityAsTask(Rec)
        else begin
            Clear(OpportunityStages);
            OpportunityStages.SetRange("Opportunity No.", Rec."No.");
            OpportunityStages.SetFilter("Sales Cycle Stage Description", '<>%1', '');
            if OpportunityStages.FindSet() then
                repeat
                    this.SendOpportunityCycleStages(OpportunityStages);
                until OpportunityStages.Next() = 0;
        end;

    end;

    local procedure SendOpportunityCycleStages(var OpportunityStages: Record "Opportunity Entry")
    var
        Opportunity: Record Opportunity;
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
        RecRef: RecordRef;
        DimeDSConnectorSetup: Record "Dime DS Connector Setup";
        DimeDSSetup: Record "Dime DS Setup";
        DSWebservMgt: Codeunit "Dime DS Web Service Management";
    begin
        DimeDSConnectorSetup.Get();
        DimeDSSetup.Get();
        Opportunity.Get(OpportunityStages."Opportunity No.");

        DSWebservMgt.InitParameters();

        // Mandatory fields
        DSWebservMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
        DSWebservMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::Opportunity));
        DSWebservMgt.AddParameter('TaskNo', format(OpportunityStages."Sales Cycle Stage"));
        DSWebservMgt.AddParameter('JobNo', Opportunity."No.");
        DSWebservMgt.AddParameter('ShortDescription', OpportunityStages."Sales Cycle Stage Description");
        DSWebservMgt.AddParameter('Description', OpportunityStages."Sales Cycle Stage Description");

        // Fields that affect default Duration and Capacity
        DSWebservMgt.AddParameter('DurationInSeconds', DimeDSDimeSchedulerMgt.ConvertDecimaltoSeconds(4)); // Fixed 4h

        // Sending Links with the Task - up to 3 are available in mboc_upsertTask, use mboc_upsertTaskUrl for more
        RecRef.GetTable(Opportunity);
        DSWebservMgt.AddParameter('url1', DimeDSDimeSchedulerMgt.GeneratePageUrl(RecRef, 5124));
        DSWebservMgt.AddParameter('urldesc1', 'Opportunity Card');

        // Call the Dime.Scheduler web service will insert or update the Task
        DSWebservMgt.CallDimeSchedulerWS('mboc_upsertTask');
    end;

    local procedure SendOpportunityAsTask(var Opportunity: Record Opportunity)
    var
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
        RecRef: RecordRef;
        DimeDSConnectorSetup: Record "Dime DS Connector Setup";
        DimeDSSetup: Record "Dime DS Setup";
        DSWebservMgt: Codeunit "Dime DS Web Service Management";
    begin
        DimeDSConnectorSetup.Get();
        DimeDSSetup.Get();

        DSWebservMgt.InitParameters();

        // Mandatory fields
        DSWebservMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
        DSWebservMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::Opportunity));
        DSWebservMgt.AddParameter('TaskNo', Opportunity."No.");
        DSWebservMgt.AddParameter('JobNo', Opportunity."No.");
        DSWebservMgt.AddParameter('ShortDescription', Opportunity.Description);
        DSWebservMgt.AddParameter('Description', Opportunity.Description);

        // Fields that affect default Duration and Capacity
        DSWebservMgt.AddParameter('DurationInSeconds', DimeDSDimeSchedulerMgt.ConvertDecimaltoSeconds(4)); // Fixed 4h

        // Sending Links with the Task - up to 3 are available in mboc_upsertTask, use mboc_upsertTaskUrl for more
        RecRef.GetTable(Opportunity);
        DSWebservMgt.AddParameter('url1', DimeDSDimeSchedulerMgt.GeneratePageUrl(RecRef, 5124));
        DSWebservMgt.AddParameter('urldesc1', 'Opportunity Card');

        // Call the Dime.Scheduler web service will insert or update the Task
        DSWebservMgt.CallDimeSchedulerWS('mboc_upsertTask');
    end;

    procedure DeleteOpportunity(Opportunity: Record Opportunity)
    var
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
        DimeDSConnectorSetup: Record "Dime DS Connector Setup";
        DimeDSSetup: Record "Dime DS Setup";
        DSWebservMgt: Codeunit "Dime DS Web Service Management";
    begin
        DimeDSConnectorSetup.Get();
        DimeDSSetup.Get();

        if Opportunity."No." <> '' then begin
            DSWebservMgt.InitParameters();

            DSWebservMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
            DSWebservMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::Opportunity));
            DSWebservMgt.AddParameter('JobNo', Opportunity."No.");
            DSWebservMgt.AddParameter('CheckAppointments', DSWebservMgt.HandleBool(DimeDSSetup."Check Appointment on Delete"));

            DSWebservMgt.CallDimeSchedulerWS('mboc_deleteJob');
        end;
    end;

    procedure EnsureDSSourceTypes()
    var
        DSSourceType: Record "Dime DS Source Type";
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
            DSSourceType."Processing Codeunit No." := Codeunit::"DS Handle Opportunity Demo";
            DSSourceType.Insert();
        end;
    end;
}