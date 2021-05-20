/// <summary>
/// 
/// #DocuSign
/// </summary>
page 50078 "DocuSignEnvelopeRecipientsVRS"
{
    Caption = 'Envelope Recipients';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = DocuSignEnvelopeRecipientVRS;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recipient Type"; "Recipient Type")
                {
                    ApplicationArea = All;
                }
                field("Recipient Code"; "Recipient Code")
                {
                    ApplicationArea = All;
                }
                field("DocuSign Carbon Copy"; "DocuSign Carbon Copy")
                {
                    Caption = 'Carbon Copy';
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Caption = 'Recipient Name';
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    Caption = 'Recipient E-Mail';
                    ApplicationArea = All;
                }
                field("On Send"; "On Send")
                {
                    ApplicationArea = All;
                }
                field("On Us Sign"; "On Us Sign")
                {
                    ApplicationArea = All;
                }
                field("On Customer Sign"; "On Customer Sign")
                {
                    ApplicationArea = All;
                }
                field("On Us Decline"; "On Us Decline")
                {
                    ApplicationArea = All;
                }
                field("On Customer Decline"; "On Customer Decline")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

