/// <summary>
/// #VRSCHR IT-3.1.11,
/// #DocuSign
/// </summary>
tableextension 50019 "CustomerExtVRS" extends Customer
{
    fields
    {
        // field(50000; AgreementPostingVRS; Enum AgreementPostingVRS)
        // {
        //     Caption = 'Agreement Posting';

        //     trigger OnValidate()
        //     var
        //         CustLedgEntry: Record "Cust. Ledger Entry";
        //     begin
        //         if AgreementPostingVRS = AgreementPostingVRS::Mandatory then begin
        //             CustLedgEntry.Reset();
        //             CustLedgEntry.SetCurrentKey("Customer No.");
        //             CustLedgEntry.SetRange("Customer No.", "No.");
        //             CustLedgEntry.SetRange(AgreementNoVRS, '');
        //             if CustLedgEntry.FindFirst() then
        //                 AgreementMgtVRS.CreateAgrmtFromCust(Rec, '');
        //         end;
        //         if AgreementPostingVRS = AgreementPostingVRS::NoAgreement then begin
        //             CustLedgEntry.Reset();
        //             CustLedgEntry.SetCurrentKey("Customer No.");
        //             CustLedgEntry.SetRange("Customer No.", "No.");
        //             CustLedgEntry.SETFILTER(AgreementNoVRS, '<> %1', '');
        //             CustLedgEntry.SetRange(Open, true);
        //             if not CustLedgEntry.IsEmpty() then
        //                 Error(ChangeAgreementErr, FieldCaption(AgreementPostingVRS), TableCaption);
        //         END;
        //     end;
        // }
        // field(50001; AgreementFilterVRS; Code[20])
        // {
        //     Caption = 'Agreement Filter';
        //     FieldClass = FlowFilter;
        //     TableRelation = CustomerAgreementVRS.No where(CustomerNo = field("No."));
        // }
        field(50002; AgreementNosVRS; Code[20])
        {
            Caption = 'Agreement Nos.';
            TableRelation = "No. Series";
        }
        field(50007; AddressIDVRS; Integer)
        {
            Caption = 'Address ID';
            DataClassification = CustomerContent;
        }
        field(50008; DocumentIDVRS; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document ID';
        }
        field(50009; ValidTillVRS; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Valid Till';
        }
        field(50010; IssuedByVRS; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Issued By';
        }
        // field(50011; GenderTypeVRS; Enum GenderTypeVRS)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Gender Type';
        // }
        field(50020; "Use DocuSign"; Boolean)
        {
            Caption = 'Use DocuSign';
        }
        field(50021; "Signer No."; Code[20])
        {
            Caption = 'Signer No.';
            TableRelation = Contact."No." WHERE(Type = FILTER(Person));
        }
        field(50022; "Allow edit SO signed CAF"; Boolean)
        {
            Caption = 'Allow editing SO in any CAF Status';
        }
    }

    // trigger OnAfterInsert()
    // var
    //     SecureObjectSetupVRS: Record SecureObjectSetupVRS;
    // begin
    //     SecureObjectSetupVRS.Get();
    //     AgreementNosVRS := SecureObjectSetupVRS.CustomerAgreementNos;
    // end;

    var
        //AgreementMgtVRS: Codeunit AgreementMgtVRS;
        ChangeAgreementErr: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.', Comment = '%1 = Field caption, %2 = Table caption';
}