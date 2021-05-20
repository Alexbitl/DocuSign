/// <summary>
/// #VRSCHR IT-3.1.11
/// #VRSCHR IT-3.1.17
/// #DocuSign
/// </summary>
pageextension 50002 "CustomerCardExtVRS" extends "Customer Card"
{
    layout
    {
        addafter(PricesandDiscounts)
        {
            group(DocuSign)
            {
                Caption = 'DocuSign';
                part(Reciptent; DocuSignEnvelopeRecipientsVRS)
                {
                    Editable = "Use DocuSign";
                    ShowFilter = false;
                    SubPageLink = "Customer No." = FIELD("No.");
                    SubPageView = SORTING("Customer No.", "Order No.", "Recipient Type", "Recipient Code")
                                  WHERE("Order No." = FILTER(''));
                    UpdatePropagation = Both;
                }
                field("Use DocuSign"; Rec."Use DocuSign")
                {
                    Importance = Promoted;
                    ToolTip = '';
                }
                field("Signer No."; Rec."Signer No.")
                {
                    Editable = Rec."Use DocuSign";
                    ToolTip = '';
                }
            }
        }
    }

    var
        FullAddress: Text;
        CurrPageEditable: Boolean;
        AddressFieldsEditable: Boolean;


    var
        PartnerTypeEmptyErr: Label 'The field Partner Type must be filled!';
}