/// <summary>
/// 
/// #DocuSign
/// </summary>
codeunit 50020 "DocuSignManagementVRS"
{
    trigger OnRun()
    begin
        FillCAFSignerSalesHeader();
    end;

    var
        CantDeleteSalesHeaderErrTxt: Label 'CAF signing via DocuSign is in progress. You can''t delete Sales Header %1.\You have to cancel CAF signing.';
        CantPostWithoutDocuSignErrTxt: Label 'CAF signing via DocuSign doesn''t exist. You can''t post Sales Header %1.';
        CantPostWithUnsignedDocuSignErrTxt: Label 'CAF isn''t sign by both parties via DocuSign. You can''t post Sales Header %1.';
        SignatureRequestEMailSubjectTxt: Label '%1 PLEASE REVIEW AND SIGN MERA %2 CAF';
        SignatureRequestEMailBodyTxt3: Label 'Dear Sir, I am sending your (CAF) for service provided in %1. Please review. Once signed, I will issue your %1  invoice. Thanks so much, %2';
        DeleteRecipientsSetupConfirmTxt: Label 'Envelope Resipients for the Sales document will deleted and recreated from the Customer Envelope Recipients.\Do you want to continue?';
        CancelledByUser: Label 'Cancelled by user.';
        DocuSignSetup: Record DocuSignSetupVRS;
        //Web: DotNet Web;
        EMailSubjectText: Label 'Sales Order ќМ%1 CAF status was not changed within 10 days.';
        EMailBodyText: Label '<a href="%1">Sales Order ќМ%2</a> CAF status was not changed within 10 days. Please Send CAF to Docusign again or reopen Sales Order for correcting.';
        CantReopenSalesHeaderErrTxt: Label 'CAF signing via DocuSign is in porgress. You can''t reopen Sales Header %1.\You have to cancel CAF signing.';
        YouHaventEnoughPremessionToReopenSOTxt: Label 'You have not enough permission to reopen Sales order with DocuSign signing.';
        ApiClient: DotNet ApiClient;
        YouHaventEnoughPremessionToViodDocuSignEnvelopeErrTxt: Label 'You have not enough permission to void DocuSign signing.';
        ConnectionIsntConfigErrTxt: Label '%1 connection isn''t configured.';
        ValidateSharePointConnectErrTxt: Label 'Cannot connect because the user name and password have not been specified, or because the connection was canceled.';
        SharePointLibraryWasntFoundErrTxt: Label 'SharePoint document library %1 wasn''t found.';
        CouldNotConnectErrTxt: Label 'Could not login to %1!\\The returned errormessage was:\%2';
        NoPrivateKeyTxt: Label 'Please upload private key at DocuSign setup page';
        CantUnchekcCustUseDocuSignErrTxt: Label 'You can''t uncheck %1. There are DocuSign Envelopes in-progress.';
        YouCannotVoidEnvelopeWithStatusErrTxt: Label 'You can''t void DocuSign Envelope with Status %1.';
        DocuSignStatusShouldBeErrTxt: Label 'Docusign Status should be њЧ%1њШ';
        PostSalesInvoiceWithDocuSignConfirmTxt: Label 'This Customer uses DocuSign, do you want to proceed with posting manual Sales Invoice without Docusign process?';
        ResultResendingCAFTxt: Label 'The result of resending CAF is "%1"';
        SignatureRequestEMailBody1Txt: Label 'Dear Customer,';
        SignatureRequestEMailBody2Txt: Label 'Attached is your Customer Acceptance Form (CAF) for service provided. Please review, and if you agree with what is presented, click the button.';
        SignatureRequestEMailBody3Txt: Label 'Once signed, your %1 invoice will be issued.';
        SignatureRequestEMailBody4Txt: Label 'Best regards,';
        SignatureRequestEMailBody5Txt: Label 'This mailbox is only for submitting PDF forms. Please do not reply to this e-mail. If you have questions, please contact your PRM or finance contact within MERA.';
        ResendEMailSubjectTxt: Label 'Reminder: %1 њЫ PLEASE REVIEW AND SIGN MERA %2 CAF';
        ResendEMailBody1Txt: Label 'I''d like to follow up on the %1 CAF sent to you via DocuSign by separate e-mail. May we kindly ask you to review it. If you are in agreement with what''s presented in the CAF, please click the "SIGN" button.';
        ResendEMailBody2Txt: Label 'In case of any question please feel free to contact me or your PRM. Thank you for you support on this.';
        MonthName01: Label 'Jan';
        MonthName02: Label 'Feb';
        MonthName03: Label 'Mar';
        MonthName04: Label 'Apr';
        MonthName05: Label 'May';
        MonthName06: Label 'Jun';
        MonthName07: Label 'Jul';
        MonthName08: Label 'Aug';
        MonthName09: Label 'Sep';
        MonthName10: Label 'Oct';
        MonthName11: Label 'Nov';
        MonthName12: Label 'Dec';
        ErrorCountRecipientsTxt: Label 'The number of recipients %1 exceeds CC Recipients Limit %2 for this SO. Do you wish to continue?';
        ContinueTxt: Label 'Do you wish to continue?';
        EmptyString: Text[1];
        DotUtils: Codeunit DocuSignDotNetUtils;
        SignApi: DotNet SignApi;

    [TryFunction]
    local procedure LoginApi(var Accountid: Text)
    var
        AuthenticationApi: DotNet AuthenticationApi;
        LoginInformation: DotNet LoginInformation;
        LoginAccount: DotNet LoginAccount;
        LoginOptions: DotNet AuthenticationApi_LoginOptions;
        ExceptionL: DotNet Exception;
        AuthHeader: Text;
    begin
        DocuSignSetup.GET;

        AuthenticationApi := AuthenticationApi.AuthenticationApi(ApiClient);
        LoginInformation := AuthenticationApi.Login(LoginOptions.LoginOptions);

        FOREACH LoginAccount IN LoginInformation.LoginAccounts DO BEGIN
            IF LoginAccount.IsDefault = 'true' THEN BEGIN
                Accountid := LoginAccount.AccountId;
                BREAK;
            END;
        END;

        IF Accountid = '' THEN BEGIN
            LoginAccount := LoginInformation.LoginAccounts.Item(0);
            Accountid := LoginAccount.AccountId;
        END;
    end;

    local procedure Authorize(var AccountId: Text)
    var
        Scopes: DotNet List_Of_T;
        LoginException: DotNet Exception;
        PrivateKey: DotNet ByteArray;
        Configuration: DotNet Configuration;
    begin
        DocuSignSetup.GET;
        // ApiClient := ApiClient.ApiClient(DocuSignSetup."Base URL" + '/restapi');
        ApiClient := SignApi.BuildClient(DocuSignSetup."Base URL");

        DotUtils.ListString(Scopes);
        Scopes.Add('signature');
        Scopes.Add('impersonation');

        if not DocuSignSetup.ExportPrivateRSAKeyBytes(PrivateKey) then begin
            Error(NoPrivateKeyTxt);
        end;

        ApiClient.RequestJWTUserToken(
            DocuSignSetup."Integrator Key",
            DocuSignSetup."API Username",
            DocuSignSetup."OAuth Base Path",
            PrivateKey,
            1,
            Scopes
        );

        IF NOT LoginApi(AccountId) THEN BEGIN
            LoginException := GetLastErrorObject();
            Error(CouldNotConnectErrTxt, 'DocuSign', LoginException.Message);
        END;
    end;

    procedure RequestSign(SignerContactP: Record Contact; RecipientsSetupP: Record DocuSignEnvelopeRecipientVRS; DocumentPathP: Text; FileNameP: Text; var SalesHeaderP: Record "Sales Header"): Text
    var
        CompanyInfoL: Record "Company Information";
        CFOEmployeeL: Record Employee;
        CustomerL: Record Customer;
        ListL: DotNet List_Of_T;
        DocumentL: DotNet DocumentE;
        SignerL: DotNet Signer;
        CarbonCopyL: DotNet CarbonCopy;
        RecipientsL: DotNet Recipients;
        EnvelopeDefinitionL: DotNet EnvelopeDefinition;
        EnvelopesApiL: DotNet EnvelopesApi;
        EnvelopeSummaryL: DotNet EnvelopeSummary;
        CreateEnvelopeOptionsL: DotNet EnvelopesApi_CreateEnvelopeOptions;
        SystemIOFileL: DotNet File;
        ByteArrayL: DotNet Array;
        SystemConvertL: DotNet Convert;
        EmptyStringL: DotNet String;
        AccountId: Text;
        EnterTextL: Text;
        BodyTextL: Text;
        EnterCharacterL: Char;
        CharL: Char;
        RecipientIDL: Integer;
        RoutingOrderL: Integer;
        FileMgtL: Codeunit "File Management";
    begin
        Authorize(AccountId);

        CharL := 8212;
        CompanyInfoL.GET;
        CustomerL.GET(SalesHeaderP."Sell-to Customer No.");
        CFOEmployeeL.GET(CompanyInfoL."CFO No.");
        EnvelopeDefinitionL := SignApi.BuildEnvelopeDefinition();
        EnvelopeDefinitionL.EmailSubject :=
          STRSUBSTNO(
            SignatureRequestEMailSubjectTxt,
            CustomerL.Name + ' ' + FORMAT(CharL),
            UPPERCASE(FORMAT(SalesHeaderP."Posting Date", 0, '<Month Text>')));

        EnterCharacterL := 13;
        EnterTextL := FORMAT(EnterCharacterL);
        EnterCharacterL := 10;
        EnterTextL := EnterTextL + FORMAT(EnterCharacterL);
        BodyTextL :=
          SignatureRequestEMailBody1Txt + EnterTextL +
          EnterTextL +
          SignatureRequestEMailBody2Txt + EnterTextL +
          EnterTextL +
          STRSUBSTNO(SignatureRequestEMailBody3Txt, FORMAT(SalesHeaderP."Posting Date", 0, '<Month Text>')) + EnterTextL +
          EnterTextL +
          SignatureRequestEMailBody4Txt + EnterTextL +
          EnterTextL;

        CASE UPPERCASE(COMPANYNAME) OF
            'MERA_USA':
                BodyTextL := BodyTextL + 'MERA USA Accounting' + EnterTextL + EnterTextL;
            'MERA_CHE':
                BodyTextL := BodyTextL + 'Mera Switzerland Accounting' + EnterTextL + EnterTextL
            ELSE
                BodyTextL := BodyTextL + 'Mera Accounting' + EnterTextL + EnterTextL;
        END;

        BodyTextL := BodyTextL +
          FORMAT(CharL) + EnterTextL +
          SignatureRequestEMailBody5Txt;

        EnvelopeDefinitionL.EmailBlurb := BodyTextL;

        ByteArrayL := SystemIOFileL.ReadAllBytes(DocumentPathP);
        DocumentL := SignApi.BuildDocument();
        DocumentL.DocumentBase64 := SystemConvertL.ToBase64String(ByteArrayL);
        DocumentL.Name := FileNameP;
        DocumentL.DocumentId := '1';

        DotUtils.ListDocument(ListL);
        ListL.Add(DocumentL);
        EnvelopeDefinitionL.Documents := ListL;

        CFOEmployeeL.GET(CompanyInfoL."CFO No.");
        EnvelopeDefinitionL.Recipients := SignApi.BuildRecipients();

        DotUtils.ListSigner(ListL);
        CreateSigner(CFOEmployeeL."E-Mail", CFOEmployeeL.FullName, 1, 1, 400, 680, SignerL);
        ListL.Add(SignerL);
        CreateSigner(SignerContactP."E-Mail", SignerContactP.Name, 2, 2, 100, 680, SignerL);
        ListL.Add(SignerL);
        EnvelopeDefinitionL.Recipients.Signers := ListL;

        CLEAR(ListL);
        //RecipientsSetupP.SETRANGE("Order No.",RecipientsSetupP."Order No.");
        RecipientsSetupP.SETRANGE("Order No.", SalesHeaderP."No.");
        RecipientsSetupP.SETRANGE("DocuSign Carbon Copy", TRUE);
        IF NOT RecipientsSetupP.ISEMPTY THEN BEGIN
            // IF RecipientsSetupP.COUNT > SalesHeaderP."CC Recipients Limit" THEN
            //     IF NOT CONFIRM(STRSUBSTNO(ErrorCountRecipientsTxt, RecipientsSetupP.COUNT, SalesHeaderP."CC Recipients Limit")) THEN
            //         ERROR('');

            DotUtils.ListCarbonCopy(ListL);
            EnvelopeDefinitionL.Recipients.CarbonCopies := ListL;
            RecipientIDL := 2;
            RoutingOrderL := 2;

            IF RecipientsSetupP.FINDSET THEN
                REPEAT
                    RecipientIDL += 1;
                    RoutingOrderL += 1;

                    CreateCarbonCopy(RecipientsSetupP."E-Mail", RecipientsSetupP.Name, RecipientIDL, RoutingOrderL, CarbonCopyL);
                    EnvelopeDefinitionL.Recipients.CarbonCopies.Add(CarbonCopyL);
                UNTIL RecipientsSetupP.NEXT = 0;
        END;

        EnvelopeDefinitionL.Status := 'sent';
        EnvelopesApiL := EnvelopesApiL.EnvelopesApi(ApiClient);
        EnvelopeSummaryL := EnvelopesApiL.CreateEnvelope(AccountId, EnvelopeDefinitionL, CreateEnvelopeOptionsL.CreateEnvelopeOptions);

        EXIT(EnvelopeSummaryL.EnvelopeId);
    end;

    procedure ResendCAF(SalesHeaderP: Record "Sales Header")
    var
        SalesHeaderL: Record "Sales Header";
        CustomerL: Record Customer;
        CustSignerL: Record Contact;
        DocuSignEnvelopeL: Record DocuSignEnvelopeVRS;
        SMTPMailSetupL: Record "SMTP Mail Setup";
        TempEmailItemL: Record "Email Item" temporary;
        EnvelopesApiL: DotNet EnvelopesApi;
        EnvelopeL: DotNet Envelope;
        EnvelopeOptionsL: DotNet EnvelopesApi_GetEnvelopeOptions;
        EnvelopeUpdateSummaryL: DotNet EnvelopeUpdateSummary;
        EnvelopeDefinitionL: DotNet EnvelopeDefinition;
        UpdateOptionsL: DotNet EnvelopesApi_UpdateOptions;
        RecipientsL: DotNet Recipients;
        RecipientsUpdateSummaryL: DotNet RecipientsUpdateSummary;
        UpdateRecipientsOptionsL: DotNet EnvelopesApi_UpdateRecipientsOptions;
        RecipientsUpdateResultsL: DotNet RecipientUpdateResponse;
        ListL: DotNet List_Of_T;
        SignerL: DotNet Signer;
        EmptyStringL: DotNet String;
        AccountId: Text;
        ErrorDetailsL: Text;
        BodyTextL: Text;
        EnterTextL: Text;
        EnterCharacterL: Char;
        FileMgtL: Codeunit "File Management";
    begin
        SalesHeaderL := SalesHeaderP;
        SalesHeaderL.SETRECFILTER;

        EnterCharacterL := 13;
        EnterTextL := FORMAT(EnterCharacterL);
        EnterCharacterL := 10;
        EnterTextL := EnterTextL + FORMAT(EnterCharacterL);

        CustomerL.GET(SalesHeaderL."Sell-to Customer No.");
        IF NOT CustomerL."Use DocuSign" THEN EXIT;

        IF SalesHeaderL."CAF Signer No." = '' THEN BEGIN
            CustomerL.TESTFIELD("Signer No.");
            CustSignerL.GET(CustomerL."Signer No.");
        END ELSE
            CustSignerL.GET(SalesHeaderL."CAF Signer No.");

        CustSignerL.TESTFIELD("E-Mail");

        DocuSignEnvelopeL.SETRANGE("Order No.", SalesHeaderL."No.");
        DocuSignEnvelopeL.SETRANGE("Posted Invoice No.", '');
        IF DocuSignEnvelopeL.FINDLAST THEN
            IF DocuSignEnvelopeL.Status <> DocuSignEnvelopeL.Status::"Signed by us" THEN
                ERROR(DocuSignStatusShouldBeErrTxt, DocuSignEnvelopeL.Status::"Signed by us");

        TempEmailItemL.Init;
        TempEmailItemL.VALIDATE("Send to", CustSignerL."E-Mail");
        TempEmailItemL.Subject :=
          STRSUBSTNO(ResendEMailSubjectTxt,
          CustomerL.Name,
          UPPERCASE(FORMAT(SalesHeaderP."Posting Date", 0, '<Month Text>')));
        BodyTextL :=
          EnterTextL + EnterTextL +
          STRSUBSTNO(ResendEMailBody1Txt, UPPERCASE(FORMAT(SalesHeaderP."Posting Date", 0, '<Month Text>'))) +
          EnterTextL + ResendEMailBody2Txt;
        TempEmailItemL.SetBodyText(BodyTextL);
        TempEmailItemL."Plaintext Formatted" := TRUE;
        //IF NOT FileMgtL.CanRunDotNetOnClient THEN BEGIN
        IF NOT TempEmailItemL.Send(FALSE) THEN EXIT;
        // END ELSE BEGIN
        //     IF NOT TempEmailItemL.SendViaOutlook THEN EXIT;
        // END;

        Authorize(AccountId);

        EnvelopesApiL := EnvelopesApiL.EnvelopesApi(ApiClient);
        EnvelopeL := EnvelopesApiL.GetEnvelope(AccountId, DocuSignEnvelopeL.ID, EnvelopeOptionsL);
        RecipientsL := RecipientsL.Recipients(GetDotNetType(EmptyString));

        DotUtils.ListSigner(ListL);
        RecipientsL.Signers := ListL;
        CreateSigner(CustSignerL."E-Mail", CustSignerL.Name, 2, 2, 100, 680, SignerL);
        RecipientsL.Signers.Add(SignerL);

        UpdateRecipientsOptionsL := UpdateRecipientsOptionsL.UpdateRecipientsOptions;
        UpdateRecipientsOptionsL.resendEnvelope('true');
        RecipientsUpdateSummaryL := EnvelopesApiL.UpdateRecipients(AccountId, DocuSignEnvelopeL.ID, RecipientsL, UpdateRecipientsOptionsL);

        // DotUtils.ListRecipientUpdateResponse(ListL);
        ListL := RecipientsUpdateSummaryL.RecipientUpdateResults;
        IF ListL.Count > 0 THEN BEGIN
            RecipientsUpdateResultsL := ListL.Item(0);
            MESSAGE(STRSUBSTNO(ResultResendingCAFTxt, FORMAT(RecipientsUpdateResultsL.ErrorDetails.ErrorCode)));
        END;
    end;

    local procedure CreateSigner(RecipientEMailP: Text[80]; RecipientNameP: Text; RecipientIDP: Integer; RoutingOrderP: Integer; SignXPositionP: Integer; SignYPositionP: Integer; var SignerP: DotNet Signer)
    var
        SignHereL: DotNet SignHere;
        TabsL: DotNet Tabs;
        ListL: DotNet List_Of_T;
        TextTabL: DotNet TextE;
        DateSignedTabL: DotNet DateSigned;
    begin
        SignerP := SignApi.BuildSigner();
        SignerP.Email := RecipientEMailP;
        SignerP.Name := RecipientNameP;
        SignerP.RecipientId := FORMAT(RecipientIDP);
        SignerP.RoutingOrder := FORMAT(RoutingOrderP);

        SignerP.Tabs := SignApi.BuildTabs();
        DotUtils.ListSignHere(ListL);
        SignerP.Tabs.SignHereTabs := ListL;
        SignHereL := SignApi.BuildSignHere();
        SignHereL.DocumentId := '1';
        SignHereL.PageNumber := '1';
        SignHereL.RecipientId := FORMAT(RecipientIDP);
        SignHereL.XPosition := FORMAT(SignXPositionP);
        SignHereL.YPosition := FORMAT(SignYPositionP);
        SignerP.Tabs.SignHereTabs.Add(SignHereL);

        DotUtils.ListModelText(ListL);
        SignerP.Tabs.TextTabs := ListL;
        TextTabL := SignApi.BuildModelText();
        TextTabL.TabLabel := 'Name';
        TextTabL.Value := RecipientNameP;
        TextTabL.DocumentId := '1';
        TextTabL.PageNumber := '1';
        TextTabL.Locked := 'true';
        TextTabL.XPosition := FORMAT(SignXPositionP);
        TextTabL.YPosition := FORMAT(SignYPositionP + 65);
        SignerP.Tabs.TextTabs.Add(TextTabL);

        DotUtils.ListDateSigned(ListL);
        SignerP.Tabs.DateSignedTabs := ListL;
        DateSignedTabL := SignApi.BuildDateSigned();
        DateSignedTabL.TabLabel := 'Signing Date';
        DateSignedTabL.DocumentId := '1';
        DateSignedTabL.PageNumber := '1';
        DateSignedTabL.XPosition := FORMAT(SignXPositionP);
        DateSignedTabL.YPosition := FORMAT(SignYPositionP + 90);
        SignerP.Tabs.DateSignedTabs.Add(DateSignedTabL);
    end;

    local procedure CreateCarbonCopy(RecipientEMailP: Text[80]; RecipientNameP: Text; RecipientIDP: Integer; RoutingOrderP: Integer; var CarbonCopyP: DotNet CarbonCopy)
    var
        ListL: DotNet List_Of_T;
        RecipientsL: DotNet Recipients;
    begin
        CarbonCopyP := CarbonCopyP.CarbonCopy(GetDotNetType(EmptyString));
        CarbonCopyP.Email := RecipientEMailP;
        CarbonCopyP.Name := RecipientNameP;
        CarbonCopyP.RecipientId := FORMAT(RecipientIDP);
        CarbonCopyP.RoutingOrder := FORMAT(RoutingOrderP);
    end;

    procedure UpdateOneEnvelopeStatus(var EnvelopeP: Record DocuSignEnvelopeVRS)
    var
        EnvelopesApiL: DotNet EnvelopesApi;
        EnvelopeL: DotNet Envelope;
        EnvelopeOptionsL: DotNet EnvelopesApi_GetEnvelopeOptions;
        ListRecipientsOptionsL: DotNet EnvelopesApi_ListRecipientsOptions;
        RecipientsL: DotNet Recipients;
        SignerL: DotNet Signer;
        Scopes: DotNet List_Of_T;
        ListL: DotNet List_Of_T;
        SystemIOFileL: DotNet File;
        ByteArrayL: DotNet Array;
        AccountId: Text;
        MeraStatusL: Text;
        SignerStatusL: Text;
        EnvelopeStatusL: Text;
        FileMgtL: Codeunit "File Management";
    begin
        Authorize(AccountId);

        EnvelopesApiL := EnvelopesApiL.EnvelopesApi(ApiClient);
        EnvelopeL := EnvelopesApiL.GetEnvelope(AccountId, EnvelopeP.ID, EnvelopeOptionsL);
        EnvelopeStatusL := EnvelopeL.Status;

        RecipientsL := EnvelopesApiL.ListRecipients(AccountId, EnvelopeP.ID, ListRecipientsOptionsL.ListRecipientsOptions);

        ListL := RecipientsL.Signers;
        SignerL := ListL.Item(0);
        MeraStatusL := LOWERCASE(SignerL.Status);

        SignerL := ListL.Item(1);
        SignerStatusL := LOWERCASE(SignerL.Status);

        EnvelopeP.VALIDATE("Signer 1 Envelope Status", MeraStatusL);
        EnvelopeP.VALIDATE("Signer 2 Envelope Status", SignerStatusL);
        IF LOWERCASE(EnvelopeStatusL) = 'voided' THEN
            EnvelopeP.VALIDATE(Status, EnvelopeP.Status::Voided);
        EnvelopeP.MODIFY(TRUE);
    end;

    procedure UpdateEnvelopeOverdueSigning(var EnvelopeP: Record DocuSignEnvelopeVRS)
    begin
        IF (CALCDATE('<10D>', EnvelopeP."Last Reminder Date") <= TODAY) AND
          (EnvelopeP.Status IN [EnvelopeP.Status::"Not Signed", EnvelopeP.Status::"Signed by us"]) THEN BEGIN
            SendReminderToFinController(EnvelopeP);
            EnvelopeP."Last Reminder Date" := TODAY;
            EnvelopeP.MODIFY(TRUE);
        END;
    end;

    procedure VoidEnvelope(var EnvelopeP: Record DocuSignEnvelopeVRS)
    var
        UserSetupL: Record "User Setup";
        EnvelopesApiL: DotNet EnvelopesApi;
        EnvelopeL: DotNet Envelope;
        EnvelopeOptionsL: DotNet EnvelopesApi_GetEnvelopeOptions;
        EnvelopeUpdateSummaryL: DotNet EnvelopeUpdateSummary;
        UpdateOptionsL: DotNet EnvelopesApi_UpdateOptions;
        Scopes: DotNet List_Of_T;
        AccountId: Text;
    begin
        UserSetupL.GET(USERID);
        IF NOT UserSetupL."Allow Void Docusign Envelope" THEN
            ERROR(YouHaventEnoughPremessionToViodDocuSignEnvelopeErrTxt);

        IF EnvelopeP.Status > EnvelopeP.Status::"Signed by Both Parties" THEN
            ERROR(YouCannotVoidEnvelopeWithStatusErrTxt, EnvelopeP.Status);

        Authorize(AccountId);

        EnvelopesApiL := EnvelopesApiL.EnvelopesApi(ApiClient);
        EnvelopeL := EnvelopesApiL.GetEnvelope(AccountId, EnvelopeP.ID, EnvelopeOptionsL);
        EnvelopeL.Status('voided');
        EnvelopeL.VoidedReason('Voided by Mera');
        EnvelopeL.PurgeState('');
        EnvelopeUpdateSummaryL := EnvelopesApiL.Update(AccountId, EnvelopeP.ID, EnvelopeL, UpdateOptionsL);

        EnvelopeP.VALIDATE(Status, EnvelopeP.Status::Voided);
        EnvelopeP.MODIFY(TRUE);
    end;

    local procedure SendReminderToFinController(var EnvelopeP: Record DocuSignEnvelopeVRS)
    var
        CompanyInfoL: Record "Company Information";
        TempEmailItemL: Record "Email Item" temporary;
        SalesOrderL: Record "Sales Header";
        ServerInstanceL: Record "Server Instance";
        RecRefL: RecordRef;
        PageMgtL: Codeunit "Page Management";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        UrlLinkL: Text;
        Body: Text;
        Subject: Text;
    begin
        IF NOT SalesOrderL.GET(SalesOrderL."Document Type"::Order, EnvelopeP."Order No.") THEN
            EXIT;
        SalesOrderL.SETRECFILTER;

        CompanyInfoL.GET;
        CompanyInfoL.CALCFIELDS("Financial Controller Email");
        RecRefL.OPEN(DATABASE::"Sales Header");
        RecRefL.GET(SalesOrderL.RECORDID);

        ServerInstanceL.GET(SERVICEINSTANCEID);
        UrlLinkL := PageMgtL.GetWebUrl(RecRefL, 42);
        UrlLinkL := COPYSTR(UrlLinkL, STRPOS(UrlLinkL, 'WebClient'));
        UrlLinkL := 'https://' + ServerInstanceL."Server Computer Name" + '/' + UPPERCASE(ServerInstanceL."Server Instance Name") + '_AZURE/' + UrlLinkL;

        Body := STRSUBSTNO(EMailBodyText, UrlLinkL, EnvelopeP."Order No.");
        Subject := STRSUBSTNO(EMailSubjectText, EnvelopeP."Order No.");

        EmailMessage.Create(CompanyInfoL."Financial Controller Email", Subject, Body);
        Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);

    end;

    procedure TestDocuSignConnection()
    var
        Encoding: DotNet Encoding;
        Scopes: DotNet List_Of_T;
        AccountId: Text;
    begin
        //#kay
        IF NOT IsDocuSignConfigured THEN
            ERROR(ConnectionIsntConfigErrTxt, 'DocuSign');

        Authorize(AccountId);
    end;

    local procedure IsDocuSignConfigured(): Boolean
    begin
        WITH DocuSignSetup DO BEGIN
            IF NOT FINDFIRST THEN
                EXIT(FALSE);

            IF (DocuSignSetup."Base URL" = '') OR
              (DocuSignSetup."Integrator Key" = '') OR
              (DocuSignSetup."API Username" = '') OR
              (DocuSignSetup."OAuth Base Path" = '') THEN
                EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    local procedure GetSignedCAFDocument(EnvelopeP: Record DocuSignEnvelopeVRS): Text
    var
        SalesHeaderL: Record "Sales Header";
        EnvelopesApiL: DotNet EnvelopesApi;
        DocumentsL: DotNet EnvelopeDocumentsResult;
        GetDocumentOptionsL: DotNet EnvelopesApi_GetDocumentOptions;
        DocStreamL: DotNet Stream;
        FileStreamL: DotNet FileStream;
        FileModeL: DotNet FileMode;
        SeekOriginL: DotNet SeekOrigin;
        AccountId: Text;
        CAFDocumentFileNameL: Text;
        FileMgtL: Codeunit "File Management";
    begin
        Authorize(AccountId);

        SalesHeaderL.SETRANGE("No.", EnvelopeP."Order No.");
        SalesHeaderL.FINDFIRST;
        CAFDocumentFileNameL := FileMgtL.ServerTempFileName('pdf');
        CAFDocumentFileNameL := FileMgtL.GetDirectoryName(CAFDocumentFileNameL);
        CAFDocumentFileNameL := CAFDocumentFileNameL + '\' +
          ReplaceBadCharacters('CAF-S_' + SalesHeaderL."Sell-to Customer Name" + '_' +
          SalesHeaderL."External Document No." + '_' + SalesHeaderL."No." + '_' +
          GetMonthName(SalesHeaderL."Posting Date") + '-' + FORMAT(SalesHeaderL."Posting Date", 0, '<Year>') + '_' +
          FORMAT(TIME, 0, '<Hours24,2><Filler Character,0><Minutes,2>')) + '.pdf';

        EnvelopesApiL := EnvelopesApiL.EnvelopesApi(ApiClient);
        DocStreamL := EnvelopesApiL.GetDocument(
          AccountId, EnvelopeP.ID, '1', GetDocumentOptionsL.GetDocumentOptions);
        FileStreamL := FileStreamL.FileStream(CAFDocumentFileNameL, FileModeL.Create);
        DocStreamL.Seek(0, SeekOriginL.Current);
        DocStreamL.CopyTo(FileStreamL);
        FileStreamL.Close;
        EXIT(CAFDocumentFileNameL);
    end;

    procedure UpdateRecipientsByDefault(SalesHeaderP: Record "Sales Header")
    var
        DefaultRecipientsL: Record DocuSignEnvelopeRecipientVRS;
        DocumentRecipientsL: Record DocuSignEnvelopeRecipientVRS;
        CustomerL: Record Customer;
    begin
        IF CustomerL.GET(SalesHeaderP."Sell-to Customer No.") THEN
            IF CustomerL."Use DocuSign" THEN BEGIN
                DefaultRecipientsL.SETRANGE("Customer No.", CustomerL."No.");
                DefaultRecipientsL.SETFILTER("Order No.", '%1', '');
                IF DefaultRecipientsL.FINDSET THEN BEGIN
                    DocumentRecipientsL.SETRANGE("Customer No.", CustomerL."No.");
                    DocumentRecipientsL.SETRANGE("Order No.", SalesHeaderP."No.");

                    IF NOT DocumentRecipientsL.ISEMPTY THEN
                        IF NOT CONFIRM(DeleteRecipientsSetupConfirmTxt, FALSE) THEN
                            ERROR(CancelledByUser)
                        ELSE
                            DocumentRecipientsL.DELETEALL;

                    DocumentRecipientsL.SETRANGE("Customer No.");
                    DocumentRecipientsL.SETRANGE("Order No.");

                    REPEAT
                        DocumentRecipientsL.INIT;
                        DocumentRecipientsL := DefaultRecipientsL;
                        DocumentRecipientsL."Order No." := SalesHeaderP."No.";
                        DocumentRecipientsL.INSERT(TRUE);
                    UNTIL DefaultRecipientsL.NEXT = 0;
                END;
            END;
    end;

    // local procedure SelectCAFWordLayout(SalesHeaderP: Record "Sales Header")
    // var
    //     LinesCountL: Integer;
    // begin
    //     LinesCountL := CalcCAFLinesCount(SalesHeaderP);

    //     CASE TRUE OF
    //         LinesCountL <= 15:
    //             TakeCAFWordLayout('1305-000015');
    //         (LinesCountL <= 25) AND (LinesCountL > 15):
    //             TakeCAFWordLayout('1305-000025');
    //         (LinesCountL <= 30) AND (LinesCountL > 25):
    //             TakeCAFWordLayout('1305-000030');
    //         LinesCountL > 30:
    //             TakeCAFWordLayout('1305-000099');
    //     END;
    // end;

    // local procedure CalcCAFLinesCount(SalesHeaderP: Record "Sales Header"): Integer
    // var
    //     SalesLineL: Record "Sales Line";
    //     TmpLineL: Record "Sales Line" temporary;
    // begin
    //     SalesLineL.RESET;
    //     SalesLineL.SETRANGE("Document Type", SalesHeaderP."Document Type");
    //     SalesLineL.SETRANGE("Document No.", SalesHeaderP."No.");
    //     SalesLineL.SETFILTER("Qty. to Ship", '<>0');
    //     exit(SalesLineL.Count);
    //     IF SalesLineL.FINDSET THEN
    //         REPEAT
    //             TmpLineL.SETRANGE("Extended Description", SalesLineL."Extended Description");
    //             IF TmpLineL.FIND('-') THEN BEGIN
    //                 TmpLineL."Qty. to Ship" += SalesLineL."Qty. to Ship";
    //                 TmpLineL.MODIFY;
    //             END ELSE BEGIN
    //                 TmpLineL.COPY(SalesLineL);
    //                 TmpLineL.INSERT;
    //             END;
    //         UNTIL SalesLineL.NEXT = 0;

    //     EXIT(TmpLineL.COUNT);
    // end;

    // local procedure TakeCAFWordLayout(CAFWorldLayoutCodeP: Code[20])
    // var
    //     DefaultCustomReportLayoutL: Record "Custom Report Layout";
    //     CustomReportLayoutL: Record "Custom Report Layout";
    //     TempBlobL: Record "99008535" temporary;
    // begin
    //     DefaultCustomReportLayoutL.GET('1305-000000');
    //     DefaultCustomReportLayoutL.LOCKTABLE;

    //     CustomReportLayoutL.GET(CAFWorldLayoutCodeP);

    //     CustomReportLayoutL.UpdateLayout(TRUE, FALSE);
    //     IF NOT CustomReportLayoutL.Layout.HASVALUE THEN
    //         EXIT;

    //     TempBlobL.INIT;
    //     TempBlobL.Blob := CustomReportLayoutL.Layout;

    //     DefaultCustomReportLayoutL.ImportLayoutBlob(TempBlobL, 'DOCX');
    // end;

    // local procedure FillEnvelopeCustomer()
    // var
    //     EnvelopeL: Record DocuSignEnvelopeVRS;
    //     SalesHeaderL: Record "Sales Header";
    //     SalesInvHeaderL: Record "Sales Invoice Header";
    //     EnvelopeCountL: Integer;
    // begin
    //     IF EnvelopeL.FINDSET(TRUE, FALSE) THEN
    //         REPEAT
    //             IF SalesHeaderL.GET(SalesHeaderL."Document Type"::Order, EnvelopeL."Order No.") THEN BEGIN
    //                 EnvelopeL."Customer No." := SalesHeaderL."Sell-to Customer No.";
    //                 EnvelopeL.MODIFY;
    //                 EnvelopeCountL += 1;
    //             END ELSE BEGIN
    //                 IF SalesInvHeaderL.GET(EnvelopeL."Posted Invoice No.") THEN BEGIN
    //                     EnvelopeL."Customer No." := SalesInvHeaderL."Sell-to Customer No.";
    //                     EnvelopeL.MODIFY;
    //                     EnvelopeCountL += 1;
    //                 END;
    //             END;
    //         UNTIL EnvelopeL.NEXT = 0;

    //     MESSAGE('Complete: %1', EnvelopeCountL);
    // end;

    local procedure FillCAFSignerSalesHeader()
    var
        SalesHeaderL: Record "Sales Header";
        CustomerL: Record Customer;
    begin
        IF SalesHeaderL.FINDSET THEN
            REPEAT
                IF CustomerL.GET(SalesHeaderL."Sell-to Customer No.") THEN BEGIN
                    IF CustomerL."Use DocuSign" THEN BEGIN
                        IF (SalesHeaderL."CAF Signer No." = '') OR (SalesHeaderL."CAF Signer Name" = '') THEN BEGIN
                            SalesHeaderL.VALIDATE("CAF Signer No.", CustomerL."Signer No.");
                            SalesHeaderL.MODIFY;
                        END;
                    END;
                END;
            UNTIL SalesHeaderL.NEXT = 0;

        MESSAGE('Complete!');
    end;

    // procedure SendUnsignedCAF(var SalesHeaderP: Record "Sales Header")
    // var
    //     SalesHeaderL: Record "Sales Header";
    //     SharePointFolderUrlL: Text;
    //     CAFDocumentFileNameL: Text;
    //     SendCAFMgtL: Codeunit "50003";
    //     FileMgtL: Codeunit "File Management";
    // begin
    //     SharePointFolderUrlL := FORMAT(SalesHeaderP."Posting Date", 0, '<Year4>/<Month,2>') + '/';
    //     CreateSharePointFolder(SharePointFolderUrlL);

    //     CAFDocumentFileNameL :=
    //       ReplaceBadCharacters('CAF-M_' + SalesHeaderP."Sell-to Customer Name" + '_' +
    //       SalesHeaderP."External Document No." + '_' + SalesHeaderP."No." + '_' +
    //       GetMonthName(SalesHeaderP."Posting Date") + '-' + FORMAT(SalesHeaderP."Posting Date", 0, '<Year>') + '_' +
    //       FORMAT(TIME, 0, '<Hours24,2><Filler Character,0><Minutes,2>')) + '.pdf';
    //     CAFDocumentFileNameL := SendCAFMgtL.SaveUnsignedCAFToPdf(SalesHeaderP, CAFDocumentFileNameL);
    //     UploadCAFDocumentToSharePoint(CAFDocumentFileNameL, SharePointFolderUrlL);

    //     SalesHeaderL.GET(SalesHeaderP."Document Type", SalesHeaderP."No.");
    //     SalesHeaderL."Unsigned CAF Link" :=
    //       DocuSignSetup."SharePoint URL" + '/' +
    //       DocuSignSetup."SharePoint Library Name" + '/' +
    //       SharePointFolderUrlL + FileMgtL.GetFileName(CAFDocumentFileNameL);
    //     SalesHeaderL.MODIFY(TRUE);
    // end;

    procedure GetMonthName(MonthsDate: Date) Name: Text
    var
        MonthNo: Integer;
    begin
        MonthNo := DATE2DMY(MonthsDate, 2);
        CASE MonthNo OF
            1:
                Name := MonthName01;
            2:
                Name := MonthName02;
            3:
                Name := MonthName03;
            4:
                Name := MonthName04;
            5:
                Name := MonthName05;
            6:
                Name := MonthName06;
            7:
                Name := MonthName07;
            8:
                Name := MonthName08;
            9:
                Name := MonthName09;
            10:
                Name := MonthName10;
            11:
                Name := MonthName11;
            12:
                Name := MonthName12;
        END;
    end;

    procedure ReplaceBadCharacters(TextLineP: Text): Text
    var
        NewTextLineL: Text;
    begin
        NewTextLineL := TextLineP;
        NewTextLineL := CONVERTSTR(NewTextLineL, '~', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '"', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '#', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '%', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '&', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '*', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, ':', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '<', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '>', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '?', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '/', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '\', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '|', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '{', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '}', '_');
        NewTextLineL := CONVERTSTR(NewTextLineL, '.', '_');

        EXIT(NewTextLineL);
    end;

    [EventSubscriber(ObjectType::Table, 1400, 'OnRegisterServiceConnection', '', false, false)]
    local procedure HandleDocuSignRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        DocuSignSetup: Record DocuSignSetupVRS;
        RecRef: RecordRef;
    begin
        IF NOT DocuSignSetup.GET THEN BEGIN
            IF NOT DocuSignSetup.WRITEPERMISSION THEN
                EXIT;
            DocuSignSetup.INIT;
            DocuSignSetup.INSERT;
        END;

        RecRef.GETTABLE(DocuSignSetup);

        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        IF (DocuSignSetup."API Username" = '') OR
          (DocuSignSetup."Integrator Key" = '') OR
          (DocuSignSetup."Base URL" = '') OR
          (DocuSignSetup."OAuth Base Path" = '') THEN
            ServiceConnection.Status := ServiceConnection.Status::Disabled;

        // WITH DocuSignSetup DO
        //     ServiceConnection.InsertServiceConnection(
        //       ServiceConnection, RecRef.RECORDID, TABLECAPTION, '', PAGE::"DocuSign Setup");
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure CheckEnvelopeOnBeforeSalesHeaderDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        EnvelopeL: Record DocuSignEnvelopeVRS;
    begin
        IF Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] THEN BEGIN
            EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
            EnvelopeL.SETRANGE("Order No.", Rec."No.");
            EnvelopeL.SETFILTER("Posted Invoice No.", '%1', '');
            IF EnvelopeL.FINDLAST THEN
                IF EnvelopeL.Status < EnvelopeL.Status::"Declined by us" THEN
                    ERROR(CantDeleteSalesHeaderErrTxt, Rec."No.");
        END;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteEnvelopeOnAfterSalesHeaderDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        EnvelopeL: Record DocuSignEnvelopeVRS;
    begin
        IF Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] THEN BEGIN
            EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
            EnvelopeL.SETRANGE("Order No.", Rec."No.");
            EnvelopeL.SETFILTER("Posted Invoice No.", '%1', '');
            IF NOT EnvelopeL.ISEMPTY THEN
                EnvelopeL.DELETEALL(TRUE);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteRecipientsOnAfterSalesHeaderDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        RecipientsL: Record DocuSignEnvelopeRecipientVRS;
    begin
        IF Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] THEN BEGIN
            RecipientsL.SETRANGE("Order No.", Rec."No.");
            IF NOT RecipientsL.ISEMPTY THEN
                RecipientsL.DELETEALL;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CheckEnvelopeOnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CustomerL: Record Customer;
        EnvelopeL: Record DocuSignEnvelopeVRS;
        UserSetupL: Record "User Setup";
    begin
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                BEGIN
                    IF NOT CONFIRM(PostSalesInvoiceWithDocuSignConfirmTxt, FALSE) THEN
                        ERROR(CancelledByUser);
                END;

            SalesHeader."Document Type"::Order:
                BEGIN
                    //MC-391-GS 2018-03-06 >>
                    UserSetupL.GET(USERID);
                    IF UserSetupL."Post with any Docusign Status" THEN
                        EXIT;
                    //MC-391-GS 2018-03-06 <<

                    IF CustomerL.GET(SalesHeader."Sell-to Customer No.") THEN
                        IF CustomerL."Use DocuSign" THEN BEGIN
                            EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
                            EnvelopeL.SETRANGE("Order No.", SalesHeader."No.");
                            //MC-391-GS 2018-03-01 >>
                            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                                EnvelopeL.SETRANGE("Posted Invoice No.", '');
                            //MC-391-GS 2018-03-01 <<
                            IF EnvelopeL.FINDLAST THEN BEGIN
                                IF EnvelopeL.Status <> EnvelopeL.Status::"Signed by Both Parties" THEN
                                    ERROR(CantPostWithUnsignedDocuSignErrTxt, SalesHeader."No.");
                            END ELSE
                                ERROR(CantPostWithoutDocuSignErrTxt, SalesHeader."No.");
                        END;
                END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReopenSalesDoc', '', false, false)]
    local procedure CheckEnvelopeOnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CustomerL: Record Customer;
        EnvelopeL: Record DocuSignEnvelopeVRS;
        UserSetupL: Record "User Setup";
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] THEN
            IF CustomerL.GET(SalesHeader."Sell-to Customer No.") THEN
                IF CustomerL."Use DocuSign" THEN BEGIN
                    EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
                    EnvelopeL.SETRANGE("Order No.", SalesHeader."No.");
                    //MC-391-GS 2018-03-01 >>
                    IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                        EnvelopeL.SETRANGE("Posted Invoice No.", '');
                    //MC-391-GS 2018-03-01 <<
                    IF EnvelopeL.FINDLAST THEN BEGIN
                        UserSetupL.GET(USERID);
                        IF NOT UserSetupL."Allow Reopen SO With DocuSign" THEN
                            ERROR(YouHaventEnoughPremessionToReopenSOTxt)
                        ELSE BEGIN
                            // MC-#1800697-ZhV 2018-09-13 >>
                            //          IF CustomerL."Allow edit SO signed CAF" THEN BEGIN
                            //            IF EnvelopeL.Status < EnvelopeL.Status::"Signed by Both Parties" THEN
                            //              ERROR(CantReopenSalesHeaderErrTxt,SalesHeader."No.");
                            //          END ELSE BEGIN
                            //            IF EnvelopeL.Status < EnvelopeL.Status::"Declined by MERA" THEN
                            //              ERROR(CantReopenSalesHeaderErrTxt,SalesHeader."No.");
                            //            END;
                            //          END;

                            IF NOT CustomerL."Allow edit SO signed CAF" THEN BEGIN
                                IF EnvelopeL.Status IN
                                  [EnvelopeL.Status::"Signed by us",
                                EnvelopeL.Status::"Signed by Both Parties"] THEN
                                    Error(CantReopenSalesHeaderErrTxt, SalesHeader."No.");
                            END;
                        END;
                        // MC-#1800697-ZhV 2018-09-13 <<
                    END;
                END;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeValidateEvent', 'Use DocuSign', false, false)]
    local procedure CheckEnvelopesOnBeforeValidateUseDocuSignFieldOnCustomer(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        EnvelopeL: Record DocuSignEnvelopeVRS;
        UserSetup: Record "User Setup";
    begin
        IF (Rec."Use DocuSign" = FALSE) AND (xRec."Use DocuSign" = TRUE) THEN BEGIN
            EnvelopeL.SETRANGE("Customer No.", Rec."No.");
            EnvelopeL.SETFILTER(Status, '<=%1', EnvelopeL.Status::"Signed by us");
            IF EnvelopeL.FINDSET THEN
                REPEAT
                    UpdateOneEnvelopeStatus(EnvelopeL);
                UNTIL EnvelopeL.NEXT = 0;

            EnvelopeL.SETFILTER(Status, '%1|%2', EnvelopeL.Status::"Not Signed", EnvelopeL.Status::"Signed by us");
            IF NOT EnvelopeL.ISEMPTY THEN BEGIN

                // 001 >>
                UserSetup.GET(USERID);
                IF NOT UserSetup."DocuSign Super User" THEN BEGIN
                    // 001 <<
                    ERROR(CantUnchekcCustUseDocuSignErrTxt, Rec.FIELDCAPTION("Use DocuSign"))
                    // 001 >>
                END ELSE BEGIN
                    IF NOT CONFIRM(STRSUBSTNO('%1 %2',
                        STRSUBSTNO(CantUnchekcCustUseDocuSignErrTxt, Rec.FIELDCAPTION("Use DocuSign")),
                        ContinueTxt))
                    THEN
                        ERROR('');
                END;
                // 001 <<
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReopenSalesDoc', '', false, false)]
    local procedure DeleteEnvelopeOnAfterReopenSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CustomerL: Record Customer;
        EnvelopeL: Record DocuSignEnvelopeVRS;
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] THEN
            IF CustomerL.GET(SalesHeader."Sell-to Customer No.") THEN
                IF CustomerL."Use DocuSign" THEN BEGIN
                    EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
                    EnvelopeL.SETRANGE("Order No.", SalesHeader."No.");
                    IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                        EnvelopeL.SETRANGE("Posted Invoice No.", '');
                    IF CustomerL."Allow edit SO signed CAF" THEN BEGIN
                        IF EnvelopeL.Status > EnvelopeL.Status::"Signed by Both Parties" THEN
                            EnvelopeL.DELETEALL(TRUE);
                    END ELSE
                        EnvelopeL.DELETEALL(TRUE);
                END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeFinalizePosting', '', false, false)]
    local procedure ModifyEnvelopeBeforeFinalizePosting(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var EverythingInvoiced: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    //local procedure ModifyEnvelopeOnFinalizePostSalesDoc(var SalesHeader: Record "Sales Header"; EverythingInvoiced: Boolean; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        EnvelopeL: Record DocuSignEnvelopeVRS;
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] THEN BEGIN
            EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
            EnvelopeL.SETRANGE("Order No.", SalesHeader."No.");
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                EnvelopeL.SETRANGE("Posted Invoice No.", '');
            // IF NOT EnvelopeL.ISEMPTY THEN BEGIN
            //     EnvelopeL.MODIFYALL("Posted Invoice No.", SalesInvHdrNo);
            // END;
        END;
    end;

    // [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    // local procedure DeleteRecipientsOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    // var
    //     RecipientsL: Record DocuSignEnvelopeRecipientVRS;
    // begin
    //     IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] THEN BEGIN
    //         RecipientsL.SETRANGE("Order No.", SalesHeader."No.");
    //         IF NOT RecipientsL.ISEMPTY THEN
    //             RecipientsL.DELETEALL;
    //     END;
    // end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure FillRecipientsSetupOnAfterValidateSellToCustomerSalesDoc(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        IF Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] THEN
            IF Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
                UpdateRecipientsByDefault(Rec);
    end;

    // [EventSubscriber(ObjectType::Page, 9305, 'OnBeforeActionEvent', 'Action151', false, false)]
    // local procedure SelectCAFLayoutOnBeforeSalesDocListPrintCAF(var Rec: Record "Sales Header")
    // begin
    //     SelectCAFWordLayout(Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, 42, 'OnBeforeActionEvent', 'Action224', false, false)]
    // local procedure SelectCAFLayoutOnBeforeSalesDocPrintCAF(var Rec: Record "Sales Header")
    // begin
    //     SelectCAFWordLayout(Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, 42, 'OnBeforeActionEvent', 'SendToDocuSign', false, false)]
    // local procedure SelectCAFLayoutOnBeforeSalesDocListSendToDocuSign(var Rec: Record "Sales Header")
    // begin
    //     SelectCAFWordLayout(Rec);
    // end;
}
dotnet
{
    assembly("MSign")
    {
        type("MSign.SignApi"; SignApi) { }
        type("MSign.TypeApi"; TypeApi) { }
    }
    assembly("DocuSign.eSign")
    {
        Version = '5.2.0.0';
        Culture = 'neutral';
        PublicKeyToken = '7fca6fcbbc219ede';

        type("DocuSign.eSign.Client.ApiClient"; "ApiClient") { }
        type("DocuSign.eSign.Client.Configuration"; "Configuration") { }
        type("DocuSign.eSign.Model.Document"; "DocumentE") { }
        type("DocuSign.eSign.Model.Signer"; "Signer") { }
        type("DocuSign.eSign.Model.CarbonCopy"; "CarbonCopy") { }
        type("DocuSign.eSign.Model.Recipients"; "Recipients") { }
        type("DocuSign.eSign.Model.EnvelopeDefinition"; "EnvelopeDefinition") { }
        type("DocuSign.eSign.Api.EnvelopesApi"; "EnvelopesApi") { }
        type("DocuSign.eSign.Model.EnvelopeSummary"; "EnvelopeSummary") { }
        type("DocuSign.eSign.Api.EnvelopesApi+CreateEnvelopeOptions"; "EnvelopesApi_CreateEnvelopeOptions") { }
        type("DocuSign.eSign.Model.Envelope"; "Envelope") { }
        type("DocuSign.eSign.Api.EnvelopesApi+GetEnvelopeOptions"; "EnvelopesApi_GetEnvelopeOptions") { }
        type("DocuSign.eSign.Model.EnvelopeUpdateSummary"; "EnvelopeUpdateSummary") { }
        type("DocuSign.eSign.Api.EnvelopesApi+UpdateOptions"; "EnvelopesApi_UpdateOptions") { }
        type("DocuSign.eSign.Model.RecipientsUpdateSummary"; "RecipientsUpdateSummary") { }
        type("DocuSign.eSign.Api.EnvelopesApi+UpdateRecipientsOptions"; "EnvelopesApi_UpdateRecipientsOptions") { }
        type("DocuSign.eSign.Model.RecipientUpdateResponse"; "RecipientUpdateResponse") { }
        type("DocuSign.eSign.Model.SignHere"; "SignHere") { }
        type("DocuSign.eSign.Model.Tabs"; "Tabs") { }
        type("DocuSign.eSign.Model.Text"; "TextE") { }
        type("DocuSign.eSign.Model.DateSigned"; "DateSigned") { }
        type("DocuSign.eSign.Api.EnvelopesApi+ListRecipientsOptions"; "EnvelopesApi_ListRecipientsOptions") { }
        type("DocuSign.eSign.Api.AuthenticationApi"; "AuthenticationApi") { }
        type("DocuSign.eSign.Model.LoginInformation"; "LoginInformation") { }
        type("DocuSign.eSign.Model.LoginAccount"; "LoginAccount") { }
        type("DocuSign.eSign.Api.AuthenticationApi+LoginOptions"; "AuthenticationApi_LoginOptions") { }
        type("DocuSign.eSign.Model.EnvelopeDocumentsResult"; "EnvelopeDocumentsResult") { }
        type("DocuSign.eSign.Api.EnvelopesApi+GetDocumentOptions"; "EnvelopesApi_GetDocumentOptions") { }
    }

    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Collections.Generic.List`1"; "List_Of_T") { }
        type("System.Byte[]"; "ByteArray") { }
    }
}


