/// <summary>
/// DocuSign
/// </summary>
enum 50032 "CAFStatusVRS"
{
    Extensible = true;

    value(0; "Not Signed")
    {
        Caption = 'Not Signed';
    }
    value(1; "Signed by us")
    {
        Caption = 'Signed by us';
    }
    value(2; "Signed by Both Parties")
    {
        Caption = 'Signed by Both Parties';
    }
    value(3; "Declined by us")
    {
        Caption = 'Declined by us';
    }
    value(4; "Declined by Customer")
    {
        Caption = 'Declined by Customer';
    }
    value(5; Voided)
    {
        Caption = 'Voided';
    }

}
