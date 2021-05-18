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
                }
                field("Recipient Code"; "Recipient Code")
                {
                }
                field("DocuSign Carbon Copy"; "DocuSign Carbon Copy")
                {
                    Caption = 'Carbon Copy';
                }
                field(Name; Name)
                {
                    Caption = 'Recipient Name';
                }
                field("E-Mail"; "E-Mail")
                {
                    Caption = 'Recipient E-Mail';
                }
                field("On Send"; "On Send")
                {
                }
                field("On Us Sign"; "On Us Sign")
                {
                }
                field("On Customer Sign"; "On Customer Sign")
                {
                }
                field("On Us Decline"; "On Us Decline")
                {
                }
                field("On Customer Decline"; "On Customer Decline")
                {
                }
            }
        }
    }

    actions
    {
    }
}

