/// <summary>
/// #VRSCHR IT-3.1.11
/// #VRSCHR IT-3.1.8
/// #DocuSign
/// </summary>
tableextension 50007 "SalesHeaderExtVRS" extends "Sales Header"
{
    fields
    {
        field(50002; EngineerNoVRS; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Engineer No';
            TableRelation = Resource where(Type = const(Person));
            ValidateTableRelation = true;
        }
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