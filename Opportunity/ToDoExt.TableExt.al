tableextension 2088006 "DS To-Do Ext Demo" extends "To-do"
{
    fields
    {
        // Add changes to table fields here
    }


    procedure SetPreventDsUpdate(PreventUpdate: Boolean)
    begin
        PreventDsUpdate := PreventUpdate;
    end;

    var
        PreventDsUpdate: Boolean;
}