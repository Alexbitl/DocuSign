/// <summary>
/// 
/// #DocuSign
/// </summary>
codeunit 50021 "DocuSignCAFSendVRS"
{
    trigger OnRun()
    begin
    end;

    var
        SuccessMessageTxt: Label 'CAF %1 was successfully sent with DocuSign.';
        ServerSaveAsPdfFailedErrTxt: Label 'Cannot open the PDF document because it is empty or cannot be created.';
        CantSendSecondSignRequestErrTxt: Label 'CAF %1 was sent with DocuSign. You can''t send CAF once again.';
        ChooseCAFOptionStringtxt: Label '&%1 (ID %2),&%3 (ID %4)';
        ChooseCAFInstuctionTxt: Label 'Select CAF Report...';
        CancelledErrTxt: Label 'Cancelled.';
        CheckSalesDocStatusErrTxt: Label 'Sales Document %1 must be %2 or %3.';

    procedure SendCAFWithDocuSign(SalesHeaderP: Record "Sales Header")
    var
        CompanyInfoL: Record "Company Information";
        CustomerL: Record Customer;
        SalesHeaderL: Record "Sales Header";
        EnvelopeL: Record DocuSignEnvelopeVRS;
        SignerL: Record Contact;
        CFOEmployeeL: Record Employee;
        RecipientsSetupL: Record DocuSignEnvelopeRecipientVRS;
        EnvelopeIDL: Text;
    begin
        SalesHeaderL := SalesHeaderP;
        //SalesHeaderL.LOCKTABLE;
        SalesHeaderL.SETRECFILTER;
        IF NOT (SalesHeaderL.Status IN [SalesHeaderL.Status::Released, SalesHeaderL.Status::"Pending Prepayment"]) THEN
            ERROR(
              CheckSalesDocStatusErrTxt,
              SalesHeaderL.FIELDCAPTION(Status),
              SalesHeaderL.Status::Released,
              SalesHeaderL.Status::"Pending Prepayment");

        CustomerL.GET(SalesHeaderL."Sell-to Customer No.");
        IF NOT CustomerL."Use DocuSign" THEN EXIT;

        CompanyInfoL.GET;
        CompanyInfoL.TESTFIELD("CFO No.");
        CFOEmployeeL.GET(CompanyInfoL."CFO No.");
        CFOEmployeeL.TESTFIELD("E-Mail");

        //CustomerL.TESTFIELD("Signer No.");
        //SignerL.GET(CustomerL."Signer No.");


        IF SalesHeaderL."CAF Signer No." = '' THEN BEGIN
            CustomerL.TESTFIELD("Signer No.");
            SignerL.GET(CustomerL."Signer No.");
        END ELSE
            SignerL.GET(SalesHeaderL."CAF Signer No.");

        SignerL.TESTFIELD("E-Mail");

        RecipientsSetupL.SETRANGE("Order No.", SalesHeaderL."No.");
        IF RecipientsSetupL.FINDSET THEN
            REPEAT
                RecipientsSetupL.TESTFIELD("E-Mail");
            UNTIL RecipientsSetupL.NEXT = 0;

        EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
        EnvelopeL.SETRANGE("Order No.", SalesHeaderL."No.");
        EnvelopeL.SETRANGE("Posted Invoice No.", '');
        IF EnvelopeL.FINDLAST THEN
            IF EnvelopeL.Status IN [EnvelopeL.Status::Voided, EnvelopeL.Status::"Declined by Customer", EnvelopeL.Status::"Declined by us"] THEN BEGIN
                EnvelopeL.DELETEALL;
                COMMIT;
            END ELSE
                ERROR(CantSendSecondSignRequestErrTxt, SalesHeaderL."No.");

        EnvelopeIDL := SendRequestSign(SignerL, RecipientsSetupL, SalesHeaderL);
        IF EnvelopeIDL <> '' THEN BEGIN
            CreateDocuSignEnvelope(EnvelopeIDL, SalesHeaderL);
            MESSAGE(SuccessMessageTxt, SalesHeaderL."No.");
        END;
    end;

    local procedure SaveCAFReportAsPdf(var SalesHeaderP: Record "Sales Header"; CIFP: Boolean; ProjectCompleteP: Boolean; FooterTextP: Text): Text[250]
    var
        FileManagementL: Codeunit "File Management";
        ServerAttachmentFilePathL: Text;
        ReportCAFL: Report "Order Confirmation";  // change to this report just for test. Replace later
    begin
        ServerAttachmentFilePathL := FileManagementL.ServerTempFileName('pdf');

        //ReportCAFL.SetInitParameters(CIFP, ProjectCompleteP, FooterTextP);
        ReportCAFL.SETTABLEVIEW(SalesHeaderP);
        ReportCAFL.SAVEASPDF(ServerAttachmentFilePathL);

        IF NOT EXISTS(ServerAttachmentFilePathL) THEN
            ERROR(ServerSaveAsPdfFailedErrTxt);

        EXIT(ServerAttachmentFilePathL);
    end;

    local procedure SetCAFReportParameters(var CIFP: Boolean; var ProjectCompleteP: Boolean; var FooterTextP: Text): Boolean
    var
        CAFOptionsL: Page CustomerAcceptanceOptionsVRS;
    begin
        IF CAFOptionsL.RUNMODAL = ACTION::Cancel THEN
            EXIT(FALSE);

        CAFOptionsL.GetParameters(CIFP, ProjectCompleteP, FooterTextP);
        EXIT(TRUE);
    end;

    local procedure SendRequestSign(SignerP: Record Contact; RecipientsSetupP: Record DocuSignEnvelopeRecipientVRS; SalesHeaderP: Record "Sales Header"): Text
    var
        DocuSignMgtL: Codeunit DocuSignManagementVRS;
        AttachmentFilePathL: Text;
        CIFL: Boolean;
        ProjectCompleteL: Boolean;
        FooterTextL: Text;
    begin
        SalesHeaderP.SETRECFILTER;
        //IF SetCAFReportParameters(CIFL, ProjectCompleteL, FooterTextL) THEN BEGIN
        AttachmentFilePathL := SaveCAFReportAsPdf(SalesHeaderP, CIFL, ProjectCompleteL, FooterTextL);
        EXIT(DocuSignMgtL.RequestSign(
          SignerP,
          RecipientsSetupP,
          AttachmentFilePathL,
          DocuSignMgtL.ReplaceBadCharacters(STRSUBSTNO(
            'CAF-S_%1_%2_%3_%4_%5.pdf',
            SalesHeaderP."Sell-to Customer Name",
            SalesHeaderP."External Document No.",
            SalesHeaderP."No.",
            DocuSignMgtL.GetMonthName(SalesHeaderP."Posting Date") + '-' +
            FORMAT(SalesHeaderP."Posting Date", 0, '<Year>'),
            FORMAT(TIME, 0, '<Hours24,2><Filler Character,0><Minutes,2>'))),
          SalesHeaderP));
        // END ELSE
        //     EXIT('');
    end;

    local procedure CreateDocuSignEnvelope(EnvelopIDP: Text; SalesHeaderP: Record "Sales Header")
    var
        CustomerL: Record Customer;
        SignerL: Record Contact;
        EnvelopL: Record DocuSignEnvelopeVRS;
        CompanyInfoL: Record "Company Information";
        CFOEmployeeL: Record Employee;
    begin
        CompanyInfoL.GET;
        CFOEmployeeL.GET(CompanyInfoL."CFO No.");

        CustomerL.GET(SalesHeaderP."Sell-to Customer No.");

        IF SalesHeaderP."CAF Signer No." = '' THEN
            SignerL.GET(CustomerL."Signer No.")
        ELSE
            SignerL.GET(SalesHeaderP."CAF Signer No.");

        EnvelopL.INIT;
        EnvelopL.ID := EnvelopIDP;
        EnvelopL."Order No." := SalesHeaderP."No.";
        EnvelopL."Signer 1 No." := CFOEmployeeL."No.";
        EnvelopL."Signer 1 E-Mail" := CFOEmployeeL."E-Mail";
        EnvelopL."Signer 1 Name" := CFOEmployeeL.FullName();//.GetFullName;
        EnvelopL."Signer 2 No." := SignerL."No.";
        EnvelopL."Signer 2 E-Mail" := SignerL."E-Mail";
        EnvelopL."Signer 2 Name" := SignerL.Name + SignerL."Name 2";
        EnvelopL.VALIDATE("Sending Date", TODAY);
        EnvelopL."Customer No." := SalesHeaderP."Sell-to Customer No.";
        EnvelopL.INSERT(TRUE);
    end;

    procedure SaveUnsignedCAFToPdf(SalesHeaderP: Record "Sales Header"; FileNameP: Text): Text
    var
        FileManagementL: Codeunit "File Management";
        CIFL: Boolean;
        ProjectCompleteL: Boolean;
        FooterTextL: Text;
        ServerFilePathL: Text;
        ServerFilePathNewL: Text;
    begin
        SalesHeaderP.SETRECFILTER;
        //IF SetCAFReportParameters(CIFL, ProjectCompleteL, FooterTextL) THEN BEGIN
        ServerFilePathL := SaveCAFReportAsPdf(SalesHeaderP, CIFL, ProjectCompleteL, FooterTextL);
        ServerFilePathNewL := FileManagementL.GetDirectoryName(ServerFilePathL) + '\' + FileNameP;
        FileManagementL.CopyServerFile(ServerFilePathL, ServerFilePathNewL, TRUE);
        FileManagementL.DeleteServerFile(ServerFilePathL);
        EXIT(ServerFilePathNewL);
        // END ELSE
        //     EXIT('');
    end;
}

