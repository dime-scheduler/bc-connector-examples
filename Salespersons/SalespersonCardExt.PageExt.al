pageextension 2088004 "DS Salesperson Card Ext Demo" extends "Salesperson/Purchaser Card"
{
    layout
    {

    }

    actions
    {
        addlast(processing)
        {
            group("DS Demo Actions")
            {
                Caption = 'Dime.Scheduler Demo';

                Action("DS Send Salesperson Demo")
                {
                    Caption = 'Send Salesperson';
                    ApplicationArea = All;
                    Image = RefreshPlanningLine;
                    ToolTip = 'Sends the selected record to Dime.Scheduler.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(codeunit::"DS Send Sales Person Demo", Rec);
                    end;
                }
            }
        }
    }
}