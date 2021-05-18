/// <summary>
/// 
/// #DocuSign
/// </summary>
pageextension 50069 "CompanyInfoVRS" extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group(DocuSign)
            {
                field("Financial Controller No."; Rec."Financial Controller No.")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
                field("Financial Controller Email"; Rec."Financial Controller Email")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
                field("Cost Controller No."; Rec."Cost Controller No.")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
                field("Cost Controller Email"; Rec."Cost Controller Email")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
                field("CFO No."; Rec."CFO No.")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
                field("CFO Email"; Rec."CFO Email")
                {
                    ApplicationArea = All;
                    ToolTip = '';
                }
            }
        }
    }
}
