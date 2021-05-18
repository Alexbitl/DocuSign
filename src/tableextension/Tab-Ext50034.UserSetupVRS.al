/// <summary>
/// #DocuSign
/// </summary>
tableextension 50034 "UserSetupVRS" extends "User Setup"
{
    fields
    {
        field(50000; "Allow Reopen SO With DocuSign"; Boolean)
        {
            Caption = 'Allow Reopen Sales Order With DocuSign';
        }
        field(50001; "Allow Void Docusign Envelope"; Boolean)
        {
            Caption = 'Allow Void Docusign Envelope';
        }
        field(50002; "Post with any Docusign Status"; Boolean)
        {
            Caption = 'Post with any Docusign Status';
        }
        field(50003; "DocuSign Super User"; Boolean)
        {
        }
    }
}
