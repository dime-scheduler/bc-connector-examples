pageextension 2088005 "DS Salesperson Ext Demo" extends "Salespersons/Purchasers"
{
    layout
    {
    }

    actions
    {
        addlast(Processing)
        {
            group("DS Demo Actions")
            {
                Caption = 'Dime.Scheduler Demo';
                Image = Planning;

                Action("DS Send Selection Demo")
                {
                    Caption = 'Send Selection';
                    ApplicationArea = All;
                    Image = RefreshLines;
                    ToolTip = 'Sends the selected record to Dime.Scheduler.';

                    trigger OnAction()
                    var
                        SalesPerson: Record "Salesperson/Purchaser";
                        DsSendResource: codeunit "DS Send Sales Person Demo";

                    begin
                        CurrPage.SETSELECTIONFILTER(SalesPerson);
                        DsSendResource.SyncSalespersons(SalesPerson);
                    end;
                }

                Action("DS Send All Demo")
                {
                    Caption = 'Send All';
                    ApplicationArea = All;
                    Image = RefreshPlanningLine;
                    Tooltip = 'Sends all records to Dime.Scheduler.';

                    trigger OnAction()
                    var
                        SalesPerson: Record "Salesperson/Purchaser";
                        DsSendResource: codeunit "DS Send Sales Person Demo";
                    begin
                        DsSendResource.SyncSalespersons(SalesPerson);
                    end;
                }
            }
        }
    }
}