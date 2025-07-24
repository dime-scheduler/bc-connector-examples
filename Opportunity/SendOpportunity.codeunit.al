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
        if not DimeDSConnectorSetup.Get() then begin
            DimeDSConnectorSetup.Init();
            DimeDSConnectorSetup.Insert();
        end;

        if not DimeDSSetup.Get() then begin
            DimeDSSetup.Init();
            DimeDSSetup.Insert();
        end;

        if not Contact.get(Rec."Contact No.") then
            exit;

        DSWebservMgt.InitParameters();

        // Mandatory fields
        DSWebservMgt.AddParameter('SourceApp', DimeDSConnectorSetup."Source App");
        DSWebservMgt.AddParameter('SourceType', DimeDSDimeSchedulerMgt.GetSourceType(DATABASE::Opportunity));
        DSWebservMgt.AddParameter('JobNo', Rec."No.");
        DSWebservMgt.AddParameter('ShortDescription', '');

        // Fields that affect the layout/view of a new Appointment
        DSWebservMgt.AddParameter('Category', '');
        DSWebservMgt.AddParameter('TimeMarker', '');

        DSWebservMgt.AddParameter('Description', Rec.Description);
        DSWebservMgt.AddParameter('Type', '');
        DSWebservMgt.AddParameter('CustomerNo', Rec."Contact No.");
        DSWebservMgt.AddParameter('CustomerName', Rec."Contact Name");
        DSWebservMgt.AddParameter('CustomerAddress', Contact.Address + ', ' + Contact."Address 2" + ', ' + Contact."Post Code" + ', ' + Contact.City);
        DSWebservMgt.AddParameter('CustomerAddressGeoLong', '');
        DSWebservMgt.AddParameter('CustomerAddressGeoLat', '');
        DSWebservMgt.AddParameter('CustomerPhone', Contact."Phone No.");
        DSWebservMgt.AddParameter('CustomerEmail', Contact."E-Mail");
        DSWebservMgt.AddParameter('ContactNo', '');
        DSWebservMgt.AddParameter('ContactName', Contact."No.");
        DSWebservMgt.AddParameter('ContactAddress', '');
        DSWebservMgt.AddParameter('ContactAddressGeoLong', '');
        DSWebservMgt.AddParameter('ContactAddressGeoLat', '');
        DSWebservMgt.AddParameter('ContactPhone', '');
        DSWebservMgt.AddParameter('ContactEmail', '');
        DSWebservMgt.AddParameter('SiteNo', '');
        DSWebservMgt.AddParameter('SiteName', '');

        // The address shown on the map in Dime.Scheduler
        DSWebservMgt.AddParameter('SiteAddress', Contact.Address + ', ' + Contact."Address 2" + ', ' + Contact."Post Code" + ', ' + Contact.City);
        DSWebservMgt.AddParameter('SiteAddressGeoLong', '');
        DSWebservMgt.AddParameter('SiteAddressGeoLat', '');

        DSWebservMgt.AddParameter('SitePhone', '');
        DSWebservMgt.AddParameter('SiteEmail', '');
        DSWebservMgt.AddParameter('SiteRegion', '');
        DSWebservMgt.AddParameter('SitePostcode', Contact."Post Code");
        DSWebservMgt.AddParameter('SiteCity', Contact."City");
        DSWebservMgt.AddParameter('SiteCounty', Contact."County");
        DSWebservMgt.AddParameter('SiteState', '');
        DSWebservMgt.AddParameter('SiteCountry', DimeDSDimeSchedulerMgt.GetCountryCode(Contact."Country/Region Code"));
        DSWebservMgt.AddParameter('SiteFromNo', '');
        DSWebservMgt.AddParameter('SiteFromName', '');
        DSWebservMgt.AddParameter('SiteFromAddress', '');
        DSWebservMgt.AddParameter('SiteFromAddressGeoLong', '');
        DSWebservMgt.AddParameter('SiteFromAddressGeoLat', '');
        DSWebservMgt.AddParameter('SiteFromPhone', '');
        DSWebservMgt.AddParameter('SiteFromEmail', '');
        DSWebservMgt.AddParameter('SiteFromRegion', '');
        DSWebservMgt.AddParameter('SiteFromPostcode', '');
        DSWebservMgt.AddParameter('SiteFromCity', '');
        DSWebservMgt.AddParameter('SiteFromCounty', '');
        DSWebservMgt.AddParameter('SiteFromState', '');
        DSWebservMgt.AddParameter('SiteFromCountry', '');
        DSWebServMgt.AddParameter('CreationDateTime', DSWebServMgt.HandleDateTime(CREATEDATETIME(Rec."Creation Date", 0T)));
        DSWebservMgt.AddParameter('Creator', CopyStr(UserId(), 1, 1024));

        // Enable the user to select this job to link it manually to an appointment
        DSWebservMgt.AddParameter('EnableManualSelection', DSWebservMgt.HandleBool(false));

        DSWebservMgt.AddParameter('FreeText1', '');
        DSWebservMgt.AddParameter('FreeText2', '');
        DSWebservMgt.AddParameter('FreeText3', '');
        DSWebservMgt.AddParameter('FreeText4', '');
        DSWebservMgt.AddParameter('FreeText5', '');
        DSWebservMgt.AddParameter('FreeText6', '');
        DSWebservMgt.AddParameter('FreeText7', '');
        DSWebservMgt.AddParameter('FreeText8', '');
        DSWebservMgt.AddParameter('FreeText9', '');
        DSWebservMgt.AddParameter('FreeText10', '');
        DSWebservMgt.AddParameter('FreeText11', '');
        DSWebservMgt.AddParameter('FreeText12', '');
        DSWebservMgt.AddParameter('FreeText13', '');
        DSWebservMgt.AddParameter('FreeText14', '');
        DSWebservMgt.AddParameter('FreeText15', '');
        DSWebservMgt.AddParameter('FreeText16', '');
        DSWebservMgt.AddParameter('FreeText17', '');
        DSWebservMgt.AddParameter('FreeText18', '');
        DSWebservMgt.AddParameter('FreeText19', '');
        DSWebservMgt.AddParameter('FreeText20', '');
        DSWebservMgt.AddParameter('FreeDecimal1', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal2', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal3', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal4', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal5', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDate1', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate2', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate3', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate4', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate5', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeBit1', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit2', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit3', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit4', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit5', DSWebservMgt.HandleBool(false));

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
        DSWebservMgt.AddParameter('ShortDescription', '');

        // Fields that affect the layout/view of a new Appointment
        DSWebservMgt.AddParameter('Category', '');
        DSWebservMgt.AddParameter('TimeMarker', '');
        DSWebservMgt.AddParameter('Subject', '');
        DSWebservMgt.AddParameter('Body', '');

        DSWebservMgt.AddParameter('Description', OpportunityStages."Sales Cycle Stage Description");
        DSWebservMgt.AddParameter('Type', '');
        DSWebservMgt.AddParameter('ServiceNo', '');
        DSWebservMgt.AddParameter('ServiceGroup', '');
        DSWebservMgt.AddParameter('ServiceClass', '');
        DSWebservMgt.AddParameter('ServiceSerialNo', '');
        DSWebservMgt.AddParameter('ServiceName', '');
        DSWebservMgt.AddParameter('IRISFault', '');
        DSWebservMgt.AddParameter('IRISSymptom', '');
        DSWebservMgt.AddParameter('IRISArea', '');
        DSWebservMgt.AddParameter('IRISReason', '');
        DSWebservMgt.AddParameter('IRISResolution', '');
        DSWebservMgt.AddParameter('Skill1', '');
        DSWebservMgt.AddParameter('Skill2', '');
        DSWebservMgt.AddParameter('Skill3', '');
        DSWebservMgt.AddParameter('ContractNo', '');
        DSWebservMgt.AddParameter('ContractType', '');
        DSWebservMgt.AddParameter('ContractDescription', '');
        DSWebservMgt.AddParameter('ContractStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('ContractEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('PartsWarrantyStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('PartsWarrantyEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('LaborWarrantyStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('LaborWarrantyEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('Status', '');//Format(AssemblyHeader.Status));
        DSWebservMgt.AddParameter('RequestedStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('RequestedEndDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ConfirmedStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ConfirmedEndDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ActualStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ActualEndDate', DSWebservMgt.HandleDateTime(0DT));

        // Fields that affect default Duration and Capacity
        DSWebservMgt.AddParameter('DurationInSeconds', DimeDSDimeSchedulerMgt.ConvertDecimaltoSeconds(14400));
        DSWebservMgt.AddParameter('PlanningUOM', '');
        DSWebservMgt.AddParameter('PlanningUOMConversion', Format(0, 0, 9));
        DSWebservMgt.AddParameter('PlanningQty', Format(0, 0, 9));
        DSWebservMgt.AddParameter('UseFixPlanningQty', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('RoundToUOM', DSWebservMgt.HandleBool(false));

        // Fields that control if the task is an Open Task
        DSWebservMgt.AddParameter('IsComplete', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('InfiniteTask', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('TaskOpenAsOf', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('TaskOpenTill', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('RequiredTotalDurationInSeconds', Format(0, 0, 9));
        DSWebservMgt.AddParameter('RequiredNoResources', Format(0, 0, 9));
        DSWebservMgt.AddParameter('DoNotCountAppointmentResource', DSWebservMgt.HandleBool(false));

        DSWebservMgt.AddParameter('AppointmentEarliestAllowed', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('AppointmentLatestAllowed', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeText1', '');
        DSWebservMgt.AddParameter('FreeText2', '');
        DSWebservMgt.AddParameter('FreeText3', '');
        DSWebservMgt.AddParameter('FreeText4', '');
        DSWebservMgt.AddParameter('FreeText5', '');
        DSWebservMgt.AddParameter('FreeText6', '');
        DSWebservMgt.AddParameter('FreeText7', '');
        DSWebservMgt.AddParameter('FreeText8', '');
        DSWebservMgt.AddParameter('FreeText9', '');
        DSWebservMgt.AddParameter('FreeText10', '');
        DSWebservMgt.AddParameter('FreeText11', '');
        DSWebservMgt.AddParameter('FreeText12', '');
        DSWebservMgt.AddParameter('FreeText13', '');
        DSWebservMgt.AddParameter('FreeText14', '');
        DSWebservMgt.AddParameter('FreeText15', '');
        DSWebservMgt.AddParameter('FreeText16', '');
        DSWebservMgt.AddParameter('FreeText17', '');
        DSWebservMgt.AddParameter('FreeText18', '');
        DSWebservMgt.AddParameter('FreeText19', '');
        DSWebservMgt.AddParameter('FreeText20', '');
        DSWebservMgt.AddParameter('FreeDecimal2', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal3', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal4', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal5', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDate1', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate2', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate3', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate4', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate5', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeBit1', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit2', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit3', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit4', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit5', DSWebservMgt.HandleBool(false));

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
        DSWebservMgt.AddParameter('ShortDescription', '');

        // Fields that affect the layout/view of a new Appointment
        DSWebservMgt.AddParameter('Category', '');
        DSWebservMgt.AddParameter('TimeMarker', '');
        DSWebservMgt.AddParameter('Subject', '');
        DSWebservMgt.AddParameter('Body', '');

        DSWebservMgt.AddParameter('Description', Opportunity.Description);
        DSWebservMgt.AddParameter('Type', '');
        DSWebservMgt.AddParameter('ServiceNo', '');
        DSWebservMgt.AddParameter('ServiceGroup', '');
        DSWebservMgt.AddParameter('ServiceClass', '');
        DSWebservMgt.AddParameter('ServiceSerialNo', '');
        DSWebservMgt.AddParameter('ServiceName', '');
        DSWebservMgt.AddParameter('IRISFault', '');
        DSWebservMgt.AddParameter('IRISSymptom', '');
        DSWebservMgt.AddParameter('IRISArea', '');
        DSWebservMgt.AddParameter('IRISReason', '');
        DSWebservMgt.AddParameter('IRISResolution', '');
        DSWebservMgt.AddParameter('Skill1', '');
        DSWebservMgt.AddParameter('Skill2', '');
        DSWebservMgt.AddParameter('Skill3', '');
        DSWebservMgt.AddParameter('ContractNo', '');
        DSWebservMgt.AddParameter('ContractType', '');
        DSWebservMgt.AddParameter('ContractDescription', '');
        DSWebservMgt.AddParameter('ContractStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('ContractEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('PartsWarrantyStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('PartsWarrantyEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('LaborWarrantyStartDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('LaborWarrantyEndDate', DSWebservMgt.HandleDate(0D));
        DSWebservMgt.AddParameter('Status', '');//Format(AssemblyHeader.Status));
        DSWebservMgt.AddParameter('RequestedStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('RequestedEndDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ConfirmedStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ConfirmedEndDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ActualStartDate', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('ActualEndDate', DSWebservMgt.HandleDateTime(0DT));

        // Fields that affect default Duration and Capacity
        DSWebservMgt.AddParameter('DurationInSeconds', DimeDSDimeSchedulerMgt.ConvertDecimaltoSeconds(14400));
        DSWebservMgt.AddParameter('PlanningUOM', '');
        DSWebservMgt.AddParameter('PlanningUOMConversion', Format(0, 0, 9));
        DSWebservMgt.AddParameter('PlanningQty', Format(0, 0, 9));
        DSWebservMgt.AddParameter('UseFixPlanningQty', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('RoundToUOM', DSWebservMgt.HandleBool(false));

        // Fields that control if the task is an Open Task
        DSWebservMgt.AddParameter('IsComplete', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('InfiniteTask', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('TaskOpenAsOf', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('TaskOpenTill', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('RequiredTotalDurationInSeconds', Format(0, 0, 9));
        DSWebservMgt.AddParameter('RequiredNoResources', Format(0, 0, 9));
        DSWebservMgt.AddParameter('DoNotCountAppointmentResource', DSWebservMgt.HandleBool(false));

        DSWebservMgt.AddParameter('AppointmentEarliestAllowed', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('AppointmentLatestAllowed', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeText1', '');
        DSWebservMgt.AddParameter('FreeText2', '');
        DSWebservMgt.AddParameter('FreeText3', '');
        DSWebservMgt.AddParameter('FreeText4', '');
        DSWebservMgt.AddParameter('FreeText5', '');
        DSWebservMgt.AddParameter('FreeText6', '');
        DSWebservMgt.AddParameter('FreeText7', '');
        DSWebservMgt.AddParameter('FreeText8', '');
        DSWebservMgt.AddParameter('FreeText9', '');
        DSWebservMgt.AddParameter('FreeText10', '');
        DSWebservMgt.AddParameter('FreeText11', '');
        DSWebservMgt.AddParameter('FreeText12', '');
        DSWebservMgt.AddParameter('FreeText13', '');
        DSWebservMgt.AddParameter('FreeText14', '');
        DSWebservMgt.AddParameter('FreeText15', '');
        DSWebservMgt.AddParameter('FreeText16', '');
        DSWebservMgt.AddParameter('FreeText17', '');
        DSWebservMgt.AddParameter('FreeText18', '');
        DSWebservMgt.AddParameter('FreeText19', '');
        DSWebservMgt.AddParameter('FreeText20', '');
        DSWebservMgt.AddParameter('FreeDecimal2', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal3', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal4', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDecimal5', Format(0, 0, 9));
        DSWebservMgt.AddParameter('FreeDate1', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate2', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate3', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate4', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeDate5', DSWebservMgt.HandleDateTime(0DT));
        DSWebservMgt.AddParameter('FreeBit1', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit2', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit3', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit4', DSWebservMgt.HandleBool(false));
        DSWebservMgt.AddParameter('FreeBit5', DSWebservMgt.HandleBool(false));

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
}