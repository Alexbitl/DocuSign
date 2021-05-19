codeunit 50023 "DocuSignDotNetUtils"
{
    procedure ListString(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeString);
    end;

    procedure ListDocument(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeDocument);
    end;

    procedure ListSigner(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeSigner);
    end;

    procedure ListCarbonCopy(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeCarbonCopy);
    end;

    procedure ListRecipientUpdateResponse(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeRecipientUpdateResponse);
    end;

    procedure ListSignHere(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeSignHere);
    end;

    procedure ListModelText(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeModelText);
    end;

    procedure ListDateSigned(var Result: DotNet List_Of_T)
    begin
        InitTypes();
        CreateGenericList(Result, TypeDateSigned);
    end;

    // ===============================================

    local procedure CreateGenericList(var Result: DotNet List_Of_T; TypeParam: DotNet Type)
    begin
        Result := Result.List(1);
        CreateInstanceOfGenericType(Result, TypeParam);
    end;

    local procedure CreateInstanceOfGenericType(var Result: DotNet Object; TypeParam: DotNet Type)
    var
        TypeParameters: DotNet Array;
        GenericType: DotNet Type;
        Activator: DotNet Activator;
    begin
        TypeParameters := TypeParameters.CreateInstance(TypeType, 1);
        TypeParameters.SetValue(TypeParam, 0);

        GenericType := GetDotNetType(Result);
        GenericType := GenericType.GetGenericTypeDefinition();
        GenericType := GenericType.MakeGenericType(TypeParameters);

        Result := Activator.CreateInstance(GenericType);
    end;

    local procedure InitTypes()
    var
        TempType: DotNet Type;
        TempList: DotNet List_Of_T;
    begin
        if Initialized then
            exit;

        TempList := TempList.List(1);
        TypeGenericList := GetDotNetType(TempList);
        TypeGenericList := TypeGenericList.GetGenericTypeDefinition();

        TypeType := TempType.GetType('System.Type');
        TypeString := TempType.GetType('System.String');
        TypeDocument := TempType.GetType('DocuSign.eSign.Model.Document');
        TypeSigner := TempType.GetType('DocuSign.eSign.Model.Signer');
        TypeCarbonCopy := TempType.GetType('DocuSign.eSign.Model.CarbonCopy');
        TypeRecipientUpdateResponse := TempType.GetType('DocuSign.eSign.Model.RecipientUpdateResponse');
        TypeSignHere := TempType.GetType('DocuSign.eSign.Model.SignHere');
        TypeModelText := TempType.GetType('DocuSign.eSign.Model.Text');
        TypeDateSigned := TempType.GetType('DocuSign.eSign.Model.DateSigned');
        Initialized := true;
    end;

    var
        Initialized: Boolean;
        TypeType: DotNet Type;
        TypeGenericList: DotNet Type;
        TypeString: DotNet Type;
        TypeDocument: DotNet Type;
        TypeSigner: DotNet Type;
        TypeCarbonCopy: DotNet Type;
        TypeRecipientUpdateResponse: DotNet Type;
        TypeSignHere: DotNet Type;
        TypeModelText: DotNet Type;
        TypeDateSigned: DotNet Type;
}