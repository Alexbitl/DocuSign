/// <summary>
/// #VRSCHR IT-3.1.11
/// #VRSCHR IT-3.1.17
/// #DocuSign
/// </summary>
pageextension 50002 "CustomerCardExtVRS" extends "Customer Card"
{
    layout
    {
        modify("Partner Type")
        {
            ShowMandatory = true;
            BlankZero = true;
            Importance = Promoted;
        }
        modify(Address)
        {
            Editable = AddressFieldsEditable;
            Visible = false;
        }
        modify("Address 2")
        {
            Editable = AddressFieldsEditable;
            Visible = false;
        }
        modify(City)
        {
            Editable = AddressFieldsEditable;
        }
        modify("Post Code")
        {
            Editable = AddressFieldsEditable;
        }
        modify("Country/Region Code")
        {
            Editable = AddressFieldsEditable;
        }
        modify(County)
        {
            Editable = AddressFieldsEditable;
        }
        addbefore(Address)
        {
            // field(GenderTypeVRS; Rec.GenderTypeVRS)
            // {
            //     Caption = 'Gender Type';
            //     ToolTip = 'Specifieds gender type';
            //     ApplicationArea = All;
            // }
            field(FullAddress; FullAddress)
            {
                Caption = 'Full Address';
                ToolTip = 'Specifieds full address';
                Editable = false;
                ApplicationArea = All;
                ShowMandatory = true;
                // trigger OnAssistEdit()
                // begin
                //     AssistEditFullAddress();
                // end;
            }
            field(AddressIDVRS; Rec.AddressIDVRS)
            {
                ApplicationArea = All;
                Caption = 'AddressID';
                ToolTip = 'Address ID';
                Visible = false;
                QuickEntry = false;
            }
        }

        // addafter(Control149)
        // {
        //     part(AttributesFactboxVRS; AttributesFactboxVRS)
        //     {
        //         ApplicationArea = Basic, Suite;
        //     }
        // }

        addafter(General)
        {
            group(AgreementsGroupVRS)
            {
                Caption = 'Agreements';

                // field(AgreemenPostingVRS; Rec.AgreementPostingVRS)
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the agreement posting associated with the customer.';
                // }
                field(AgreementNosVRS; Rec.AgreementNosVRS)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number series from which numbers are assigned to new records.';
                }
            }
        }
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

    actions
    {
        addafter(ShipToAddresses)
        {
            // action(AgreementsVRS)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Agreements';
            //     Image = Agreement;
            //     Promoted = true;
            //     PromotedCategory = Category9;
            //     PromotedIsBig = true;
            //     RunObject = Page CustomerAgreementsVRS;
            //     RunPageLink = CustomerNo = field("No.");
            //     ToolTip = 'View or edit the list of agreements for the customer.';
            // }
            // action(SecureObjectsVRS)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Secure Objects';
            //     Image = Home;
            //     Promoted = true;
            //     PromotedCategory = Category9;
            //     PromotedIsBig = true;
            //     RunPageMode = View;
            //     RunObject = Page SecureObjectVRS;
            //     RunPageLink = CustomerNo = field("No.");
            //     ToolTip = 'View the list of secure objects for the customer.';
            // }
        }
        addlast("&Customer")
        {
            // action(AttributesVRS)
            // {
            //     AccessByPermission = TableData AttributeVRS = R;
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Attributes';
            //     Image = Category;
            //     Promoted = true;
            //     PromotedCategory = Category9;
            //     PromotedIsBig = true;
            //     ToolTip = 'View or edit the attributes.';

            //     trigger OnAction()
            //     var
            //         AttributeValueEditorVRS: Page AttributeValueEditorVRS;
            //     begin
            //         AttributeValueEditorVRS.SetReference(Rec."No.", Database::Customer);
            //         AttributeValueEditorVRS.RunModal();
            //         CurrPage.SaveRecord();
            //         CurrPage.AttributesFactboxVRS.Page.LoadAttributesData(Rec."No.", Database::Customer);
            //     end;
            // }
        }
    }

    // trigger OnAfterGetCurrRecord()
    // begin
    //     CurrPage.AttributesFactboxVRS.Page.LoadAttributesData(Rec."No.", Database::Customer);
    //     CurrPageEditable := CurrPage.Editable;
    //     AddressFieldsEditable := false;
    //     GetFullAddress(Rec.AddressIDVRS);
    // end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Partner Type" = Rec."Partner Type"::" " then
            Error(PartnerTypeEmptyErr);
    end;

    // local procedure AssistEditFullAddress()
    // var
    //     TempAddressDetailedVRS: Record AddressDetailedVRS temporary;
    //     AddressTypeVRS: Enum AddressTypeVRS;
    // begin
    //     CurrPage.SaveRecord();
    //     Commit();
    //     TempAddressDetailedVRS.CopyFromCustomer(Rec, AddressTypeVRS::Default);

    //     if Page.RunModal(Page::AddressDetailedVRSCard, TempAddressDetailedVRS) = Action::LookupOK then begin
    //         Rec.GET(Rec."No.");
    //         FullAddress := copystr(TempAddressDetailedVRS.ToString(), 1, MaxStrLen(FullAddress));
    //     end;
    // end;

    // local procedure GetFullAddress(AddressID: Integer)
    // var
    //     AddressMgtVRS: Codeunit AddressMgtVRS;
    // begin
    //     FullAddress := AddressMgtVRS.GetFullAddress(AddressID);
    // end;

    var
        FullAddress: Text;
        CurrPageEditable: Boolean;
        AddressFieldsEditable: Boolean;


    var
        PartnerTypeEmptyErr: Label 'The field Partner Type must be filled!';
}