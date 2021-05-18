/// <summary>
/// DocuSign
/// </summary>
table 50047 "DocuSignEnvelopeVRS"
{
    Caption = 'DocuSign Envelope';

    fields
    {
        field(1; ID; Code[50])
        {
            Caption = 'ID';
        }
        field(2; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(3; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
        }
        field(4; "Signer 1 No."; Code[20])
        {
            Caption = 'Signer 1 No.';
            TableRelation = Employee;
            ValidateTableRelation = false;
        }
        field(5; "Signer 1 E-Mail"; Text[80])
        {
            Caption = 'Signer 1 E-Mail';
        }
        field(6; "Signer 1 Name"; Text[150])
        {
            Caption = 'Signer 1 Name';
        }
        field(7; "Signer 2 No."; Code[20])
        {
            Caption = 'Signer 2 No.';
            TableRelation = Contact;
            ValidateTableRelation = false;
        }
        field(8; "Signer 2 E-Mail"; Text[80])
        {
            Caption = 'Signer 2 E-Mail';
        }
        field(9; "Signer 2 Name"; Text[150])
        {
            Caption = 'Signer 2 Name';
        }
        field(10; Status; Enum CAFStatusVRS)
        {
            Caption = 'Status';
            trigger OnValidate()
            var
                DocuSignMgtL: Codeunit DocuSignManagementVRS;
            begin
                IF Status <> xRec.Status THEN
                    IF Status IN [Status::"Declined by us", Status::"Declined by Customer", Status::"Signed by Both Parties", Status::Voided] THEN
                        SendEMailNotificatoinToFinController;
            end;
        }
        field(11; "Sending Date"; Date)
        {
            Caption = 'Sending Date';

            trigger OnValidate()
            var
                NotificationEventL: Option " ","On Send","On Us Sign","On Customer Sign","On Us Decline","On Customer Decline";
            begin
                IF "Sending Date" <> xRec."Sending Date" THEN
                    IF "Sending Date" > 0D THEN
                        SendNotification(NotificationEventL::"On Send");

                "Last Reminder Date" := "Sending Date";
            end;
        }
        field(12; "Sharepoint URL"; Text[250])
        {
            Caption = 'Sharepoint URL';
        }
        field(13; "Signer 1 Envelope Status"; Text[50])
        {
            Caption = 'Signer 1 Envelop Status';

            trigger OnValidate()
            var
                NotificationEventL: Option " ","On Send","On Us Sign","On Customer Sign","On Us Decline","On Customer Decline";
            begin
                UpdateEnvelopStatus;

                IF "Signer 1 Envelope Status" <> xRec."Signer 1 Envelope Status" THEN BEGIN
                    IF LOWERCASE("Signer 1 Envelope Status") = 'completed' THEN
                        SendNotification(NotificationEventL::"On Us Sign");

                    IF LOWERCASE("Signer 1 Envelope Status") = 'declined' THEN
                        SendNotification(NotificationEventL::"On Us Decline");
                END;
            end;
        }
        field(14; "Signer 2 Envelope Status"; Text[50])
        {
            Caption = 'Signer 2 Envelop Status';

            trigger OnValidate()
            var
                NotificationEventL: Option " ","On Send","On Us Sign","On Customer Sign","On Us Decline","On Customer Decline";
            begin
                UpdateEnvelopStatus;

                IF "Signer 2 Envelope Status" <> xRec."Signer 2 Envelope Status" THEN BEGIN
                    IF LOWERCASE("Signer 2 Envelope Status") = 'completed' THEN
                        SendNotification(NotificationEventL::"On Customer Sign");

                    IF LOWERCASE("Signer 2 Envelope Status") = 'declined' THEN
                        SendNotification(NotificationEventL::"On Customer Decline");
                END;
            end;
        }
        field(15; "Last Reminder Date"; Date)
        {
            Caption = 'Last Reminder Date';
            Editable = false;
        }
        field(16; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
    }

    keys
    {
        key(Key1; ID)
        {
        }
        key(Key2; "Order No.", "Posted Invoice No.")
        {
        }
        key(Key3; Status)
        {
        }
    }

    fieldgroups
    {
    }

    var
        EMailSubjectText: Label 'DocuSign. CAF of Sales Order %1 was %2 on %3.';
        EMailBodyText: Label 'Hello! This is notification from DocuSign service. CAF of Sales Order %1 was %2 on %3.';
        EMailSubject2Text: Label 'Sales Order ќМ%1 CAF status changed on "%2"';
        EMailBody2Text: Label '<a href="%1">Sales Order ќМ%2</a> CAF status changed on "%3". <a href="%4">Signed CAF</a>';

    local procedure UpdateEnvelopStatus()
    begin
        IF LOWERCASE("Signer 1 Envelope Status") = 'completed' THEN
            VALIDATE(Status, Status::"Signed by us");

        IF (LOWERCASE("Signer 1 Envelope Status") = 'completed') AND (LOWERCASE("Signer 2 Envelope Status") = 'completed') THEN
            VALIDATE(Status, Status::"Signed by Both Parties");

        IF LOWERCASE("Signer 1 Envelope Status") = 'declined' THEN
            VALIDATE(Status, Status::"Declined by us");

        IF LOWERCASE("Signer 2 Envelope Status") = 'declined' THEN
            VALIDATE(Status, Status::"Declined by Customer");
    end;

    local procedure SendNotification(NotificationEventP: Option " ","On Send","On Us Sign","On Customer Sign","On Us Decline","On Customer Decline")
    var
        SalesHeaderL: Record "Sales Header";
        RecipientL: Record DocuSignEnvelopeRecipientVRS;
    begin
        SalesHeaderL.SETRANGE("No.", "Order No.");
        IF SalesHeaderL.FINDFIRST THEN BEGIN
            RecipientL.RESET;
            RecipientL.SETRANGE("Customer No.", SalesHeaderL."Sell-to Customer No.");
            RecipientL.SETRANGE("Order No.", SalesHeaderL."No.");

            CASE NotificationEventP OF
                NotificationEventP::"On Send":
                    BEGIN
                        RecipientL.SETRANGE("On Send", TRUE);
                    END;
                NotificationEventP::"On Us Sign":
                    RecipientL.SETRANGE("On Us Sign", TRUE);
                NotificationEventP::"On Customer Sign":
                    RecipientL.SETRANGE("On Customer Sign", TRUE);
                NotificationEventP::"On Us Decline":
                    RecipientL.SETRANGE("On Us Decline", TRUE);
                NotificationEventP::"On Customer Decline":
                    RecipientL.SETRANGE("On Customer Decline", TRUE);
            END;

            IF RecipientL.FINDSET THEN
                REPEAT
                    SendNotificationEMail(RecipientL."E-Mail", NotificationEventP);
                UNTIL RecipientL.NEXT = 0;
        END;
    end;

    local procedure SendNotificationEMail(EMailAddressP: Text; NotificationEventP: Option " ","On Send","On Us Sign","On Customer Sign","On Us Decline","On Customer Decline")
    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
    begin
        CASE NotificationEventP OF
            NotificationEventP::"On Send":
                BEGIN
                    Subject := STRSUBSTNO(EMailSubjectText, "Order No.", 'sent', TODAY);
                    Body := STRSUBSTNO(EMailBodyText, "Order No.", 'sent', TODAY);
                END;

            NotificationEventP::"On Us Sign":
                BEGIN
                    Subject := STRSUBSTNO(EMailSubjectText, "Order No.", 'signed by Us signer', TODAY);
                    Body := STRSUBSTNO(EMailBodyText, "Order No.",
                      'signed by Us signer ' + "Signer 1 Name", TODAY);
                END;

            NotificationEventP::"On Customer Sign":
                BEGIN
                    Subject := STRSUBSTNO(EMailSubjectText, "Order No.", 'signed by customer', TODAY);
                    Body := STRSUBSTNO(EMailBodyText, "Order No.", 'signed by customer ' + "Signer 2 Name" + ' (' + "Signer 2 E-Mail" + ')', TODAY);
                END;

            NotificationEventP::"On Us Decline":
                BEGIN
                    Subject := STRSUBSTNO(EMailSubjectText, "Order No.", 'declined by Us signer', TODAY);
                    Body := STRSUBSTNO(EMailBodyText, "Order No.", 'declined by Us signer ' + "Signer 1 Name" + ' (' + "Signer 1 E-Mail" + ')', TODAY);
                END;

            NotificationEventP::"On Customer Decline":
                BEGIN
                    Subject := STRSUBSTNO(EMailSubjectText, "Order No.", 'declined by customer', TODAY);
                    Body := STRSUBSTNO(EMailBodyText, "Order No.", 'declined by customer ' + "Signer 2 Name" + ' (' + "Signer 2 E-Mail" + ')', TODAY);
                END;
        END;
        EmailMessage.Create(EMailAddressP, Subject, Body);
        Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    local procedure SendEMailNotificatoinToFinController()
    var
        CompanyInfoL: Record "Company Information";
        SalesOrderL: Record "Sales Header";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
    begin
        CompanyInfoL.GET;
        CompanyInfoL.CALCFIELDS("Financial Controller Email");
        IF NOT SalesOrderL.GET(SalesOrderL."Document Type"::Order, "Order No.") THEN
            EXIT;

        SalesOrderL.SETRECFILTER;

        Subject := STRSUBSTNO(EMailSubject2Text, "Order No.", Status);
        Body := STRSUBSTNO(EMailBody2Text,
          GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"Sales Order", SalesOrderL), "Order No.", Status, "Sharepoint URL");

        EmailMessage.Create(CompanyInfoL."Financial Controller Email", Subject, Body);
        Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}

