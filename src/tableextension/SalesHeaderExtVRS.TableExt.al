/// <summary>
/// #VRSCHR IT-3.1.11
/// #VRSCHR IT-3.1.8
/// #DocuSign
/// </summary>
tableextension 50007 "SalesHeaderExtVRS" extends "Sales Header"
{
    fields
    {
        // field(50000; AgreementNoVRS; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Agreement No.';
        //     Editable = true;
        //     TableRelation = CustomerAgreementVRS.No where(CustomerNo = field("Bill-to Customer No."), Status = filter(Design | Active));
        //     ValidateTableRelation = true;

        //     trigger OnValidate()
        //     var
        //         CustomerAgreementVRS: Record CustomerAgreementVRS;
        //         CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
        //         OldDimSetID: Integer;
        //     begin
        //         TestField(Status, Status::Open);
        //         if (xRec.AgreementNoVRS <> AgreementNoVRS) then begin
        //             if (AgreementNoVRS <> '') then begin
        //                 if HideValidationDialog or not GuiAllowed() or (xRec.AgreementNoVRS = '') then
        //                     Confirmed := true
        //                 else
        //                     Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption(AgreementNoVRS));
        //                 if Confirmed then begin
        //                     SalesLine.SetRange("Document Type", "Document Type");
        //                     SalesLine.SetRange("Document No.", "No.");
        //                     if "Document Type" = "Document Type"::Order then
        //                         SalesLine.SetFilter("Quantity Shipped", '<>0')
        //                     else
        //                         if "Document Type" = "Document Type"::Invoice then
        //                             SalesLine.SetFilter("Shipment No.", '<>%1', '');

        //                     if SalesLine.FindFirst() then
        //                         if "Document Type" = "Document Type"::Order then
        //                             SalesLine.TestField("Quantity Shipped", 0)
        //                         else
        //                             SalesLine.TestField("Shipment No.", '');
        //                     SalesLine.SetRange("Shipment No.");
        //                     SalesLine.SetRange("Quantity Shipped");

        //                     if "Document Type" = "Document Type"::Order then begin
        //                         SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
        //                         if SalesLine.Find('-') then
        //                             SalesLine.TestField("Prepmt. Amt. Inv.", 0);
        //                         SalesLine.SetRange("Prepmt. Amt. Inv.");
        //                     end;

        //                     if "Document Type" = "Document Type"::"Return Order" then
        //                         SalesLine.SetFilter("Return Qty. Received", '<>0')
        //                     else
        //                         if "Document Type" = "Document Type"::"Credit Memo" then
        //                             SalesLine.SetFilter("Return Receipt No.", '<>%1', '');

        //                     if SalesLine.FindFirst() then
        //                         if "Document Type" = "Document Type"::"Return Order" then
        //                             SalesLine.TestField("Return Qty. Received", 0)
        //                         else
        //                             SalesLine.TestField("Return Receipt No.", '');
        //                     SalesLine.Reset();

        //                     CustomerAgreementVRS.Get("Bill-to Customer No.", AgreementNoVRS);
        //                     CustomerAgreementVRS.CheckBlockedCustOnDocs(Customer, "Document Type", false, false);
        //                     CustomerAgreementVRS.TestField(CustomerPostingGroup);
        //                     if "Posting Date" <> 0D then begin
        //                         if CustomerAgreementVRS.StartingDate > "Posting Date" then
        //                             Error(AgreementLaterErr, CustomerAgreementVRS.FieldCaption(StartingDate), FieldCaption("Posting Date"));
        //                     end else
        //                         if CustomerAgreementVRS.StartingDate > "Document Date" then
        //                             Error(AgreementLaterErr, CustomerAgreementVRS.FieldCaption(StartingDate), FieldCaption("Document Date"));

        //                     if GuiAllowed() and (CurrFieldNo <> 0) and (("Document Type" = "Document Type"::Invoice) or ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Quote)) then begin
        //                         "Amount Including VAT" := 0;
        //                         case "Document Type" of
        //                             "Document Type"::Quote, "Document Type"::Invoice:
        //                                 CustCheckCrLimit.SalesHeaderCheck(Rec);
        //                             "Document Type"::Order:
        //                                 begin
        //                                     if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
        //                                         SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        //                                         SalesLine.SetRange("Document No.", "No.");
        //                                         SalesLine.CALCSUMS("Outstanding Amount", "Shipped Not Invoiced");
        //                                         "Amount Including VAT" := SalesLine."Outstanding Amount" + SalesLine."Shipped Not Invoiced";
        //                                     end;
        //                                     CustCheckCrLimit.SalesHeaderCheck(Rec);
        //                                 end;
        //                         end;
        //                         CalcFields("Amount Including VAT");
        //                     end;

        //                     if "VAT Bus. Posting Group" <> CustomerAgreementVRS.VATBusPostingGroup then
        //                         Validate("VAT Bus. Posting Group", CustomerAgreementVRS.VATBusPostingGroup);
        //                     if "Customer Posting Group" <> CustomerAgreementVRS.CustomerPostingGroup then
        //                         Validate("Customer Posting Group", CustomerAgreementVRS.CustomerPostingGroup);
        //                     if "Currency Code" <> CustomerAgreementVRS.CurrencyCode then
        //                         Validate("Currency Code", CustomerAgreementVRS.CurrencyCode);
        //                     if "Customer Price Group" <> CustomerAgreementVRS.CustomerPriceGroup then
        //                         Validate("Customer Price Group", CustomerAgreementVRS.CustomerPriceGroup);
        //                     if "Customer Disc. Group" <> CustomerAgreementVRS.CustomerDiscGroup then
        //                         Validate("Customer Disc. Group", CustomerAgreementVRS.CustomerDiscGroup);
        //                     if "Salesperson Code" <> CustomerAgreementVRS.SalespersonCode then
        //                         Validate("Salesperson Code", CustomerAgreementVRS.SalespersonCode);

        //                     if (xRec."Currency Code" <> "Currency Code") or
        //                        (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
        //                        (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
        //                     then
        //                         RecreateSalesLines(CopyStr(FieldCaption(AgreementNoVRS), 1, 100));

        //                     OldDimSetID := "Dimension Set ID";
        //                     "Dimension Set ID" :=
        //                       CustomerAgreementVRS.GetDefaultDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        //                     UpdateAllLineDim("Dimension Set ID", OldDimSetID);

        //                     UpdateSalesLinesByFieldNo(FieldNo(AgreementNoVRS), false);
        //                 end;
        //             end else begin
        //                 HideValidationDialog := true;
        //                 Validate("Bill-to Customer No.");
        //             end;
        //         end else
        //             AgreementNoVRS := xRec.AgreementNoVRS;
        //     end;
        // }

        field(50002; EngineerNoVRS; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Engineer No';
            TableRelation = Resource where(Type = const(Person));
            ValidateTableRelation = true;
        }

        // field(50003; SecureObjectNoVRS; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Secure Object No';
        //     TableRelation = SecureObjectVRS;
        //     ValidateTableRelation = true;
        // }

        // field(50004; RequestTypeVRS; Enum OpportunityRequestTypeVRS)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Request Type';
        // }

        field(50010; CAFStatus; Enum CAFStatusVRS)
        {
            CalcFormula = Lookup(DocuSignEnvelopeVRS.Status WHERE("Order No." = FIELD("No."),
                                                                   "Posted Invoice No." = CONST('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Use DocuSign"; Boolean)
        {
            CalcFormula = Lookup(Customer."Use DocuSign" WHERE("No." = FIELD("Sell-to Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "CAF Signer No."; Code[20])
        {
            Caption = 'CAF Signer No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact."No.";

            trigger OnValidate()
            begin
                IF Contact.GET("CAF Signer No.") THEN
                    "CAF Signer Name" := Contact.Name
                ELSE
                    "CAF Signer Name" := '';
            end;
        }
        field(50013; "CAF Signer Name"; Text[100])
        {
            Caption = 'CAF Signer Name';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                VALIDATE("CAF Signer No.", "CAF Signer Name");
            end;
        }


        // modify("Sell-to Customer No.")
        // {
        //     trigger OnBeforeValidate()
        //     var
        //         Cust: Record Customer;
        //     begin
        //         if AgreementNoVRS <> '' then
        //             Error(AnotherFieldNotBlankErr, FieldCaption("Sell-to Customer No."), FieldCaption(AgreementNoVRS));
        //         if Cust.Get("Sell-to Customer No.") then
        //             "CAF Signer No." := Cust."Signer No.";
        //     end;
        // }

        // modify("Bill-to Customer No.")
        // {
        //     trigger OnBeforeValidate()
        //     begin
        //         if AgreementNoVRS <> '' then
        //             Error(AnotherFieldNotBlankErr, FieldCaption("Bill-to Customer No."), FieldCaption(AgreementNoVRS));
        //     end;
        // }
    }
    var
        Contact: Record Contact;
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        Confirmed: Boolean;
        AgreementLaterErr: Label 'Agreement %1 should be no later than %2.', Comment = '%1 = First field caption, %2 = Second field caption';
        ConfirmChangeQst: Label 'Do you want to change %1?', Comment = '%1 = a Field Caption like Currency Code';
        AnotherFieldNotBlankErr: Label 'You can not update %1 while %2 is not blank.', Comment = '%1 = First field, %2 = Second field';
        SalesDiscountLineExistErr: Label 'Line with discount is already declared. Line No. = %1', Comment = '%1 = Line No.';

    procedure CreateDiscountLineForSalesQuote()
    var
        LocalSalesLine: Record "Sales Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        TestField("Document Type", rec."Document Type"::Quote);
        GeneralLedgerSetup.Get();
        //GeneralLedgerSetup.TestField(DiscountGLAccountNoVRS);
        LocalSalesLine.SetRange("Document Type", Rec."Document Type");
        LocalSalesLine.SetRange("Document No.", Rec."No.");
        LocalSalesLine.SetRange(Type, LocalSalesLine.Type::"G/L Account");
        //LocalSalesLine.SetRange("No.", GeneralLedgerSetup.DiscountGLAccountNoVRS);
        if LocalSalesLine.FindFirst() then
            Error(SalesDiscountLineExistErr, LocalSalesLine."Line No.");

        Clear(LocalSalesLine);
        LocalSalesLine.Init();
        LocalSalesLine.Validate("Document Type", Rec."Document Type");
        LocalSalesLine.Validate("Document No.", Rec."No.");
        LocalSalesLine."Line No." := GetLastSalesLineNo() + 10000;
        LocalSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        LocalSalesLine.Validate(Type, LocalSalesLine.Type::"G/L Account");
        //LocalSalesLine.Validate("No.", GeneralLedgerSetup.DiscountGLAccountNoVRS);
        LocalSalesLine.Validate(Quantity, 1);
        //LocalSalesLine.Validate("Unit Price", -50);
        LocalSalesLine.Insert(true);
    end;

    procedure GetLastSalesLineNo(): BigInteger
    var
        LocalSalesLine: Record "Sales Line";
    begin
        LocalSalesLine.SetRange("Document Type", Rec."Document Type");
        LocalSalesLine.SetRange("Document No.", Rec."No.");
        if LocalSalesLine.FindLast() then
            exit(LocalSalesLine."Line No.")
        else
            exit(0);
    end;
}