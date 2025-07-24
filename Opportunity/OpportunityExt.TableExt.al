tableextension 2088008 "DS Opportunity Ext Demo" extends Opportunity
{
    fields
    {
        field(2088000; "DS Send Opportunity Header"; Boolean)
        {
            Caption = 'Send opportunity header as task';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }
}