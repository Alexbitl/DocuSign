/// <summary>
/// 
/// #DocuSign
/// </summary>
page 50077 "DocuSignSetupVRS"
{
    Caption = 'DocuSign Setup';
    PageType = Card;
    Permissions = TableData "Service Password" = rimd;
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
                }
                field("API Username"; "API Username")
                {
                }
                field("Base URL"; "Base URL")
                {
                }
                field("OAuth Base Path"; "OAuth Base Path")
                {
                }
                field("Private RSA Key File Name"; "Private RSA Key File Name")
                {
                    Caption = 'Private RSA Key File';
                    //Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ImportPrivateRSAKeyFile;
                    end;
                }
            }
            group(SharePoint)
            {
                Caption = 'SharePoint';
                field("SharePoint User Name"; "SharePoint User Name")
                {
                }
                field(SharePointPasswordTemp; SharePointPasswordTemp)
                {
                    Caption = 'Password';
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        SetSharePointPassword(SharePointPasswordTemp);
                        //COMMIT;
                        //CurrPage.UPDATE(TRUE);
                    end;
                }
                field("SharePoint URL"; "SharePoint URL")
                {
                    ToolTip = '';
                }
                field("SharePoint Library Name"; "SharePoint Library Name")
                {
                    ToolTip = '';
                }
                field("SharePoint Start Folder"; "SharePoint Start Folder")
                {
                    ToolTip = '';
                }
            }
            group("Shared Documents")
            {
                Caption = 'Shared Documents';
                field("SharePoint Document Repository"; "SharePoint Document Repository")
                {
                    Caption = 'Document Repository';
                }
                field("SharePoint Document Folder"; "SharePoint Document Folder")
                {
                    Caption = 'Document Folder';
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

