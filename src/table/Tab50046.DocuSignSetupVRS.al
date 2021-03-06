/// <summary>
/// DocuSign
/// </summary>
table 50046 "DocuSignSetupVRS"
{
    Caption = 'DocuSign Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Integrator Key"; Text[50])
        {
            Caption = 'Integrator Key';
        }
        field(3; "API Username"; Text[50])
        {
            Caption = 'API Username';
        }
        field(4; "Base URL"; Text[150])
        {
            Caption = 'Base URL';
            ExtendedDatatype = URL;
        }
        field(5; "OAuth Base Path"; Text[150])
        {
            Caption = 'OAuth Base Path';
        }
        field(6; "Private RSA Key"; BLOB)
        {
            Caption = 'Private RSA Key';
        }
        field(7; "SharePoint URL"; Text[250])
        {
            Caption = 'URL';
            ExtendedDatatype = URL;
        }
        field(8; "SharePoint User Name"; Text[80])
        {
            Caption = 'User Name';
        }
        field(9; "SharePoint Password Key"; Guid)
        {
            Caption = 'Password Key';
        }
        field(10; "SharePoint Library Name"; Text[150])
        {
            Caption = 'Library Name';
        }
        field(11; "Private RSA Key File Name"; Text[150])
        {
            Caption = 'Private RSA Key File Name';
        }
        field(12; "SharePoint Start Folder"; Text[150])
        {
            Caption = 'Start Folder';
        }
        field(13; "SharePoint Document Repository"; Text[150])
        {
            Caption = 'SharePoint Document Repository';
        }
        field(14; "SharePoint Document Folder"; Text[150])
        {
            Caption = 'SharePoint Document Folder';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UploadPrivateRSAKeyFileTxt: Label 'Upload Private RSA Key File (*.pem)';

    procedure SetSharePointPassword(PasswordText: Text)
    var
        ServicePassword: Record DocuSignServicePasswordVRS;
    begin
        IF ISNULLGUID("SharePoint Password Key") OR NOT ServicePassword.GET("SharePoint Password Key") THEN BEGIN
            ServicePassword.SavePassword(PasswordText);
            ServicePassword.INSERT(TRUE);
            "SharePoint Password Key" := ServicePassword.Key;
        END ELSE BEGIN
            ServicePassword.SavePassword(PasswordText);
            ServicePassword.MODIFY;
        END;
    end;

    procedure GetSharePointPassword(): Text
    var
        ServicePassword: Record DocuSignServicePasswordVRS;
    begin
        IF NOT ISNULLGUID("SharePoint Password Key") THEN
            IF ServicePassword.GET("SharePoint Password Key") THEN
                EXIT(ServicePassword.GetPassword());
    end;

    procedure ImportPrivateRSAKeyFile()
    var
        TempBLOBL: Codeunit "Temp Blob";
        FileMgtL: Codeunit "File Management";

        KeyStream: OutStream;

        ClientFileName: Text;
        ClientFileStream: InStream;
    begin
        ClientFileName := 'PrivateRSAKey.pem';

        if UploadIntoStream(UploadPrivateRSAKeyFileTxt, '', '', ClientFileName, ClientFileStream) then begin
            "Private RSA Key".CreateOutStream(KeyStream);
            CopyStream(KeyStream, ClientFileStream);

            "Private RSA Key File Name" := ClientFileName;
            Modify;
        end;
    end;

    procedure ExportPrivateRSAKeyFile(): Text
    var
        TempBLOBL: Codeunit "Temp Blob";
        FileMgtL: Codeunit "File Management";
        FilenameWithPath: Text;
        KeyStream: InStream;
        BlobStream: OutStream;
    begin
        CALCFIELDS("Private RSA Key");
        IF "Private RSA Key".HASVALUE THEN BEGIN
            "Private RSA Key".CreateInStream(KeyStream);
            TempBLOBL.CreateOutStream(BlobStream);
            CopyStream(BlobStream, KeyStream);

            FilenameWithPath := FileMgtL.ServerTempFileName('pem');
            FileMgtL.BLOBExportToServerFile(TempBLOBL, FilenameWithPath);
        END;

        EXIT(FilenameWithPath);
    end;

    procedure ExportPrivateRSAKeyBytes(var Result: DotNet ByteArray): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        BlobStream: OutStream;
        FieldStream: InStream;
        FileMgt: Codeunit "File Management";
        FilenameWithPath: Text;

        DotFile: DotNet File;
    begin
        CalcFields("Private RSA Key");

        if "Private RSA Key".HasValue then begin
            "Private RSA Key".CreateInStream(FieldStream);
            TempBlob.CreateOutStream(BlobStream);
            CopyStream(BlobStream, FieldStream);

            FilenameWithPath := FileMgt.ServerTempFileName('pem');
            FileMgt.BLOBExportToServerFile(TempBlob, FilenameWithPath);

            Result := DotFile.ReadAllBytes(FilenameWithPath);

            exit(true);
        end;

        exit(false);
    end;
}

