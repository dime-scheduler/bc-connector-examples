pageextension 2088001 "DS OpportunityCardExt Demo" extends "Opportunity Card"
{
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