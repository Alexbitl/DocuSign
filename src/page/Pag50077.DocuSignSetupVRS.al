/// <summary>
/// 
/// #DocuSign
/// </summary>
page 50077 "DocuSignSetupVRS"
{
    Caption = 'DocuSign Setup';
    PageType = Card;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = DocuSignSetupVRS;
    UsageCategory = Lists;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Integrator Key"; "Integrator Key")
                {
                    ApplicationArea = All;
                }
                field("API Username"; "API Username")
                {
                    ApplicationArea = All;
                }
                field("Base URL"; "Base URL")
                {
                    ApplicationArea = All;
                }
                field("OAuth Base Path"; "OAuth Base Path")
                {
                    ApplicationArea = All;
                }
                field("Private RSA Key File Name"; "Private RSA Key File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Private RSA Key File';
                    //Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ImportPrivateRSAKeyFile;
                    end;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Test DocuSign Connection")
            {
                Caption = 'Test DocuSign Connection';
                Image = LinkWeb;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Test the configuration settings against the DocuSign.';

                trigger OnAction()
                var
                    DocumentServiceManagement: Codeunit "Document Service Management";
                begin
                    MODIFY;
                    DocuSignMgt.TestDocuSignConnection;
                    MESSAGE(ValidateSuccessMsg, 'DocuSign');
                end;
            }
            // action("Test SharePoint Connection")
            // {
            //     Caption = 'Test SharePoint Connection';
            //     Image = ValidateEmailLoggingSetup;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ToolTip = 'Test the configuration settings against the SharePoint.';

            //     trigger OnAction()
            //     var
            //         DocumentServiceManagement: Codeunit "Document Service Management";
            //     begin
            //         MODIFY;
            //         DocuSignMgt.TestSharePointConnection;
            //         MESSAGE(ValidateSuccessMsg, 'SharePoint');
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SharePointPasswordTemp := '';
        IF ("API Username" <> '') AND (NOT ISNULLGUID("SharePoint Password Key")) THEN
            SharePointPasswordTemp := '**********';
    end;

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;

    var
        DocuSignMgt: Codeunit DocuSignManagementVRS;
        SharePointPasswordTemp: Text;
        PrivateRSAKeyFilename: Text;
        ValidateSuccessMsg: Label 'The connection settings validated correctly, and the current configuration can connect to the %1.';
}

