pageextension 2088001 "DS OpportunityCardExt Demo" extends "Opportunity Card"
{
    layout
    {
        addlast(Content)
        {
            group("DS Dime.Scheduler Tab")
            {
                Caption = 'Dime.Scheduler';

                field("DS Send Opportunity Header Tab"; Rec."DS Send Opportunity Header")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to send the opportunity header to Dime.Scheduler.';
                }
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group("DS Demo Actions")
            {
                Caption = 'Dime.Scheduler Demo';
                Image = Planning;

                action("DS Send to Dime.Scheduler Demo")
                {
                    Caption = 'Send to Dime.Scheduler';
                    Image = Planning;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DsSendOpportunity: Codeunit "DS Send Opportunity Demo";
                    begin
                        DsSendOpportunity.Run(Rec);
                    end;
                }
                action("DS DeleteFromDimeScheduler Demo")
                {
                    Caption = 'Delete from Dime.Scheduler';
                    Image = RemoveLine;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DsSendOpportunity: Codeunit "DS Send Opportunity Demo";
                    begin
                        DsSendOpportunity.DeleteOpportunity(Rec);
                    end;
                }
            }
        }
    }
}