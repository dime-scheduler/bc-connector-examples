codeunit 2088002 "DS Handle Opportunity Demo"
{
    TableNo = "Dime DS Appointment";

    trigger OnRun()
    begin
        PerformAllocation(Rec);
    end;

    local procedure PerformAllocation(DimeDSAppointment: Record "Dime DS Appointment")
    var
        DimeDSAppointmentResource: Record "Dime DS Appointment Resource";
        DimeDSOrderLineLink: Record "Dime DS Order Line Link";
        DimeDSSetup: Record "Dime DS Setup";
        Opportunity: Record Opportunity;
        ToDo: Record "To-do";
        LineNo: Integer;
    begin
        if not Opportunity.Get(DimeDSAppointment."Job No.") then
            exit; // No Opportunity found, nothing to do

        Evaluate(LineNo, DimeDSAppointment."Task No.");


        DimeDSSetup.Get();
        ToDo.SetPreventDsUpdate(true);

        if DimeDSAppointment."Database Action" = 'I' then begin
            DimeDSAppointmentResource.Reset();
            DimeDSAppointmentResource.SetRange("Entry No.", DimeDSAppointment."Entry No.");
            if DimeDSAppointmentResource.FindSet() then
                repeat
                    if (DimeDSAppointment."Sent From Backoffice") then
                        // Handle Appointment
                        InsertDSTodoLink(DimeDSAppointment, DimeDSAppointmentResource)
                    else
                        AllocateResource(DimeDSAppointment, DimeDSAppointmentResource, Opportunity);
                until DimeDSAppointmentResource.Next() = 0;
        end;

        if DimeDSAppointment."Database Action" = 'D' then begin
            DimeDSOrderLineLink.Reset();
            DimeDSOrderLineLink.SetRange("Appointment Id", DimeDSAppointment."Appointment Id");
            if DimeDSOrderLineLink.FindSet() then
                repeat
                    if Todo.Get(DimeDSOrderLineLink."Document No.") then
                        Todo.Delete(true);
                    DimeDSOrderLineLink.Delete(true);
                until DimeDSOrderLineLink.Next() = 0;
        end;

        if DimeDSAppointment."Database Action" = 'U' then begin
            // First check if Resources planned in Dime.Scheduler are allocated in NAV 
            DimeDSAppointmentResource.Reset();
            DimeDSAppointmentResource.SetRange("Entry No.", DimeDSAppointment."Entry No.");
            if DimeDSAppointmentResource.FindSet() then
                repeat
                    if (DimeDSAppointment."Sent From Backoffice") then
                        // Handle Appointment
                        UpdateDSTodoLink(DimeDSAppointment, DimeDSAppointmentResource)
                    else begin
                        DimeDSOrderLineLink.SetRange("Appointment Id", DimeDSAppointment."Appointment Id");
                        DimeDSOrderLineLink.SetRange("Resource No.", DimeDSAppointmentResource."Resource No.");
                        if DimeDSOrderLineLink.FindFirst() then begin
                            UpdateTodo(DimeDSAppointment, DimeDSAppointmentResource, DimeDSOrderLineLink);
                        end else begin
                            AllocateResource(DimeDSAppointment, DimeDSAppointmentResource, Opportunity);
                        end;
                    end;
                until DimeDSAppointmentResource.Next() = 0;

            // Then check if Resources already allocated in NAV have been deleted in Dime.Scheduler
            DimeDSOrderLineLink.Reset();
            DimeDSOrderLineLink.SetRange("Appointment Id", DimeDSAppointment."Appointment Id");
            if DimeDSOrderLineLink.FindSet() then
                repeat
                    DimeDSAppointmentResource.Reset();
                    DimeDSAppointmentResource.SetRange("Entry No.", DimeDSAppointment."Entry No.");
                    DimeDSAppointmentResource.SetRange("Resource No.", DimeDSOrderLineLink."Resource No.");
                    if DimeDSAppointmentResource.IsEmpty() then begin  // Resource has been removed in Dime.Scheduler
                        if ToDo.Get(DimeDSOrderLineLink."Document No.") then
                            ToDo.Delete(true);
                        DimeDSOrderLineLink.Delete(true);
                    end;
                until DimeDSOrderLineLink.Next() = 0;
        end;
    end;

    local procedure AllocateResource(DimeDSAppointment: Record "Dime DS Appointment"; DimeDSAppointmentResource: Record "Dime DS Appointment Resource"; Opportunity: Record Opportunity)
    var
        Salesperson: Record "Salesperson/Purchaser";
        Todo: Record "To-do";
        DimeDSOrderLineLink: Record "Dime DS Order Line Link";
        DimeDSEvents: Codeunit "Dime DS Events";
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
    begin
        if DimeDSAppointmentResource."Resource No." <> '' then
            Salesperson.Get(DimeDSAppointmentResource."Resource No.");

        Todo.Init();
        Todo.Validate(Type, Todo.Type::"Phone Call");
        Todo."Opportunity No." := Opportunity."No.";
        Todo.Description := DimeDSAppointment.Subject;
        Todo.Validate("Contact No.", Opportunity."Contact No.");
        Todo.Insert(true);

        Todo.Date := DimeDSDimeSchedulerMgt.DateTime2Date(DimeDSAppointment.Start);
        Todo."Ending Date" := DimeDSDimeSchedulerMgt.DateTime2Date(DimeDSAppointment."End");
        Todo."Salesperson Code" := Salesperson.Code;
        Todo."Ending Time" := 0T;
        Todo."Start Time" := DimeDSDimeSchedulerMgt.DateTime2Time(DimeDSAppointment.Start);
        Todo."Ending Time" := DimeDSDimeSchedulerMgt.DateTime2Time(DimeDSAppointment."End");
        Todo.Duration := DimeDSAppointment."End" - DimeDSAppointment.Start;

        Todo.Modify(true);

        DimeDSOrderLineLink.Init();
        DimeDSOrderLineLink."Appointment Id" := DimeDSAppointment."Appointment Id";
        DimeDSOrderLineLink."Resource No." := Salesperson.Code;
        DimeDSOrderLineLink."Document No." := Todo."No.";
        DimeDSOrderLineLink.Insert(true);
    end;

    local procedure UpdateTodo(DimeDSAppointment: Record "Dime DS Appointment"; DimeDSAppointmentResource: Record "Dime DS Appointment Resource"; DimeDSOrderLineLink: Record "Dime DS Order Line Link")
    var
        Todo: Record "To-do";
        DimeDSEvents: Codeunit "Dime DS Events";
        DimeDSDimeSchedulerMgt: Codeunit "Dime DS Dime.Scheduler Mgt.";
    begin
        if Todo.Get(DimeDSOrderLineLink."Document No.") then begin
            Todo.SetPreventDsUpdate(true);
            Todo.Date := DimeDSDimeSchedulerMgt.DateTime2Date(DimeDSAppointment.Start);
            Todo."Ending Date" := DimeDSDimeSchedulerMgt.DateTime2Date(DimeDSAppointment."End");
            Todo."Salesperson Code" := DimeDSAppointmentResource."Resource No.";
            Todo."Ending Time" := 0T;
            Todo."Start Time" := DimeDSDimeSchedulerMgt.DateTime2Time(DimeDSAppointment.Start);
            Todo."Ending Time" := DimeDSDimeSchedulerMgt.DateTime2Time(DimeDSAppointment."End");
            Todo.Duration := DimeDSAppointment."End" - DimeDSAppointment.Start;
            Todo.Modify(true);
        end;
    end;

    local procedure InsertDSTodoLink(DimeDSAppointment: Record "Dime DS Appointment"; DimeDSAppointmentResource: Record "Dime DS Appointment Resource")
    var
        Todo: Record "To-do";
        DimeDSOrderLineLink: Record "Dime DS Order Line Link";
        EntryNo: Integer;
    begin
        Todo.Get(DimeDSAppointment."Backoffice Id");
        Evaluate(EntryNo, Todo."No.");

        DimeDSOrderLineLink.Init();
        DimeDSOrderLineLink."Appointment Id" := DimeDSAppointment."Appointment Id";
        DimeDSOrderLineLink."Resource No." := CopyStr(DimeDSAppointmentResource."Resource No.", 1, 20);
        DimeDSOrderLineLink."Document No." := DimeDSAppointment."Backoffice Id";
        DimeDSOrderLineLink.Insert(true);
    end;

    local procedure UpdateDSTodoLink(DimeDSAppointment: Record "Dime DS Appointment"; DimeDSAppointmentResource: Record "Dime DS Appointment Resource")
    var
        Todo: Record "To-do";
        DimeDSOrderLineLink: Record "Dime DS Order Line Link";
        EntryNo: Integer;
    begin
        if not Todo.Get(DimeDSAppointment."Backoffice Id") then
            exit;
        Evaluate(EntryNo, DimeDSAppointment."Backoffice Id");

        DimeDSOrderLineLink.SetRange("Appointment Id", DimeDSAppointment."Appointment Id");
        DimeDSOrderLineLink.SetRange("Document No.", Todo."No.");
        DimeDSOrderLineLink.FindFirst();
        DimeDSOrderLineLink.Rename(DimeDSAppointment."Appointment Id", DimeDSAppointmentResource."Resource No.");
    end;
}