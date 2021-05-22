codeunit 50023 "DocuSignDotNetUtils"
{
    procedure ListString(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListString();
    end;

    procedure ListDocument(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListDocument();
    end;

    procedure ListSigner(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListSigner();
    end;

    procedure ListCarbonCopy(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListCarbonCopy();
    end;

    procedure ListRecipientUpdateResponse(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListRecipientUpdateResponse();
    end;

    procedure ListSignHere(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListSignHere();
    end;

    procedure ListModelText(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListModelText();
    end;

    procedure ListDateSigned(var Result: DotNet List_Of_T)
    begin
        Result := TypeApi.ListDateSigned();
    end;

    // ===============================================

    /*local procedure CreateGenericList(var Result: DotNet List_Of_T; TypeParam: DotNet Type)
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
    end;*/

    var
        TypeApi: DotNet TypeApi;
}