/// <summary>
/// 
/// #DocuSign
/// </summary>
page 50079 "CustomerAcceptanceOptionsVRS"
{
    Caption = 'CAF Options';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(CIF; CIF)
            {
                Caption = 'Customer Invoice Form';
            }
            field(ProjectComplete; ProjectComplete)
            {
                Caption = 'Project is complete';
            }
            field(FooterText; FooterText)
            {
                Caption = 'Footer Text';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FooterText := 'Recorded Shortfalls of the Final Project Outcome (if any):';
    end;

    var
        CIF: Boolean;
        ProjectComplete: Boolean;
        FooterText: Text;

    procedure GetParameters(var CIFP: Boolean; var ProjectCompleteP: Boolean; var FooterTextP: Text)
    begin
        CIFP := CIF;
        ProjectCompleteP := ProjectComplete;
        FooterTextP := FooterText;
    end;
}

