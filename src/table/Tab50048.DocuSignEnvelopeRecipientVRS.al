/// <summary>
/// #DocuSign
/// </summary>
table 50048 "DocuSignEnvelopeRecipientVRS"
{
    Caption = 'DocuSign Envelope Recipient';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer."No.";
        }
        field(2; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(3; "Recipient Type"; Option)
        {
            Caption = 'Recipient Type';
            OptionCaption = ' ,Salesperson,Contact';
            OptionMembers = " ",Salesperson,Contact;
        }
        field(4; "Recipient Code"; Code[20])
        {
            Caption = 'Recipient Code';
            NotBlank = true;
            TableRelation = IF ("Recipient Type" = CONST(Salesperson)) "Salesperson/Purchaser".Code
            ELSE
            IF ("Recipient Type" = CONST(Contact)) Contact."No." WHERE(Type = CONST(Person));

            trigger OnValidate()
            var
                SalespersonL: Record "Salesperson/Purchaser";
                ContactL: Record Contact;
            begin
                CASE "Recipient Type" OF
                    "Recipient Type"::Salesperson:
                        BEGIN
                            IF SalespersonL.GET("Recipient Code") THEN BEGIN
                                Name := SalespersonL.Name;
                                "E-Mail" := SalespersonL."E-Mail";
                            END;
                        END;

                    "Recipient Type"::Contact:
                        BEGIN
                            IF ContactL.GET("Recipient Code") THEN BEGIN
                                Name := ContactL.Name;
                                "E-Mail" := ContactL."E-Mail";
                            END;
                        END;
                END;
            end;
        }
        field(5; "On Send"; Boolean)
        {
            Caption = 'On Send';
        }
        field(6; "On Us Sign"; Boolean)
        {
            Caption = 'On Us Sign';
        }
        field(7; "On Customer Sign"; Boolean)
        {
            Caption = 'On Customer Sign';
        }
        field(8; "On Us Decline"; Boolean)
        {
            Caption = 'On Us Decline';
        }
        field(9; "On Customer Decline"; Boolean)
        {
            Caption = 'On Customer Decline';
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(11; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(12; "DocuSign Carbon Copy"; Boolean)
        {
            Caption = 'DocuSign Carbon Copy';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Order No.", "Recipient Type", "Recipient Code")
        {
        }
    }

    fieldgroups
    {
    }
}

