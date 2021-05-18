/// <summary>
/// DocuSign
/// </summary>
table 50049 "DocuSignServicePasswordVRS"
{
    Caption = 'DocuSign Service Password';

    fields
    {
        field(1; "Key"; Guid)
        {
            Caption = 'Key';
        }
        field(2; Value; BLOB)
        {
            Caption = 'Value';
        }
    }

    keys
    {
        key(Key1; "Key")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Key := CREATEGUID;
    end;

    procedure SavePassword(PasswordText: Text)
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        OutStream: OutStream;
    begin
        IF EncryptionManagement.IsEncryptionPossible THEN
            PasswordText := EncryptionManagement.Encrypt(PasswordText);
        Value.CREATEOUTSTREAM(OutStream);
        OutStream.WRITE(PasswordText);
    end;

    procedure GetPassword(): Text
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        InStream: InStream;
        PasswordText: Text;
    begin
        CALCFIELDS(Value);
        Value.CREATEINSTREAM(InStream);
        InStream.READ(PasswordText);
        IF EncryptionManagement.IsEncryptionPossible THEN
            EXIT(EncryptionManagement.Decrypt(PasswordText));
        EXIT(PasswordText);
    end;
}

