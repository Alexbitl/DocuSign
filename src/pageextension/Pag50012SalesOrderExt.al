pageextension 50012 SalesOrderExt extends "Sales Order"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateDocuSignInfo();
            end;
        }
    }

    actions
    {
        addafter(Plan)
        {
            group(DocuSign)
            {
                Caption = 'DocuSign';
                Enabled = ShowDocuSignFastTab;
                Image = SendAsPDF;
                action(SendToDocuSign)
                {
                    Caption = 'Send to DocuSign';
                    Enabled = ShowDocuSignFastTab;
                    Image = SendElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ToolTip = 'Send to signing via DocuSign.';

                    trigger OnAction()
                    var
                        CAFSendHandlerL: Codeunit DocuSignCAFSendVRS;
                    begin
                        CLEAR(CAFSendHandlerL);
                        CAFSendHandlerL.SendCAFWithDocuSign(Rec);
                    end;
                }
                action(UpdateCAFStatus)
                {
                    Caption = 'Update CAF Status';
                    Enabled = ShowDocuSignFastTab;
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Category10;

                    trigger OnAction()
                    var
                        EnvelopeL: Record DocuSignEnvelopeVRS;
                        DocuSignMgtL: Codeunit DocuSignManagementVRS;
                    begin
                        EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
                        EnvelopeL.SETRANGE("Order No.", "No.");
                        EnvelopeL.SETRANGE("Posted Invoice No.", '');
                        IF EnvelopeL.FINDLAST THEN
                            IF EnvelopeL.Status < EnvelopeL.Status::"Signed by Both Parties" THEN BEGIN
                                DocuSignMgtL.UpdateOneEnvelopeStatus(EnvelopeL);
                            END;
                    end;
                }
                action(ReSendToDocuSign)
                {
                    Caption = 'Resend to Customer';
                    Enabled = ShowDocuSignFastTab;
                    Image = UpdateXML;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ToolTip = 'Resend to signing to Customer.';

                    trigger OnAction()
                    var
                        CAFSendHandlerL: Codeunit DocuSignManagementVRS;
                    begin
                        CLEAR(CAFSendHandlerL);
                        CAFSendHandlerL.ResendCAF(Rec);
                    end;
                }
                action(VoidCAF)
                {
                    Caption = 'Void CAF';
                    Enabled = ShowDocuSignFastTab;
                    Image = VoidElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Category10;
                    Visible = ShowVoidCAFAction;

                    trigger OnAction()
                    var
                        EnvelopeL: Record DocuSignEnvelopeVRS;
                        DocuSignMgtL: Codeunit DocuSignManagementVRS;
                    begin
                        EnvelopeL.SETCURRENTKEY("Order No.", "Posted Invoice No.");
                        EnvelopeL.SETRANGE("Order No.", "No.");
                        EnvelopeL.SETRANGE("Posted Invoice No.", '');
                        IF EnvelopeL.FINDLAST THEN
                            IF EnvelopeL.Status < EnvelopeL.Status::"Signed by Both Parties" THEN BEGIN
                                DocuSignMgtL.VoidEnvelope(EnvelopeL);
                            END;
                    end;
                }
                action(SetDefaultRecipientsSetup)
                {
                    Caption = 'Set Default Recipients Setup';
                    Enabled = ShowDocuSignFastTab;
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ToolTip = 'Set Default Recipients Setup.';

                    trigger OnAction()
                    var
                        DocuSignMgtL: Codeunit DocuSignManagementVRS;
                    begin
                        DocuSignMgtL.UpdateRecipientsByDefault(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateDocuSignInfo();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateDocuSignInfo();
    end;

    trigger OnOpenPage()
    begin
        UpdateDocuSignInfo();
    end;

    var
        DocuSignEnvelop: Record DocuSignEnvelopeVRS;
        Signer: Record Contact;
        ShowDocuSignFastTab: Boolean;
        ShowVoidCAFAction: Boolean;
        ShowSendUnsignedCAF: Boolean;
        SignerEditable: Boolean;

    local procedure UpdateDocuSignInfo()
    var
        CustomerL: Record Customer;
        UserSetupL: Record "User Setup";
    begin
        ShowDocuSignFastTab := FALSE;
        Signer.INIT;
        IF CustomerL.GET("Sell-to Customer No.") THEN
            IF CustomerL."Use DocuSign" THEN BEGIN
                ShowDocuSignFastTab := TRUE;

                IF "CAF Signer No." = '' THEN BEGIN
                    IF NOT Signer.GET(CustomerL."Signer No.") THEN
                        Signer.INIT;
                END ELSE BEGIN
                    IF NOT Signer.GET("CAF Signer No.") THEN
                        Signer.INIT;
                END;
            END;

        ShowSendUnsignedCAF := NOT ShowDocuSignFastTab;
        UserSetupL.GET(USERID);
        ShowVoidCAFAction := UserSetupL."Allow Void Docusign Envelope";

        DocuSignEnvelop.INIT;
        DocuSignEnvelop.SETCURRENTKEY("Order No.", "Posted Invoice No.");
        DocuSignEnvelop.SETRANGE("Order No.", "No.");
        DocuSignEnvelop.SETFILTER("Posted Invoice No.", '%1', '');
        IF DocuSignEnvelop.FINDLAST THEN;

        IF DocuSignEnvelop.Status = DocuSignEnvelop.Status::"Not Signed" THEN
            SignerEditable := DocuSignEnvelop."Sending Date" = 0D
        ELSE
            SignerEditable := DocuSignEnvelop.Status IN
              [DocuSignEnvelop.Status::"Declined by us",
              DocuSignEnvelop.Status::"Declined by Customer",
              DocuSignEnvelop.Status::Voided];
    end;
}