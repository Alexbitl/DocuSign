/// <summary>
/// #DocuSign
/// </summary>
tableextension 50033 "CompanyInfoVRS" extends "Company Information"
{
    fields
    {
        field(50000; "Financial Controller No."; Code[20])
        {
            Caption = 'Financial Controller No.';
            TableRelation = Employee;
        }
        field(50001; "Cost Controller No."; Code[20])
        {
            Caption = 'Cost Controller No.';
            TableRelation = Employee;
        }
        field(50002; "CFO No."; Code[20])
        {
            Caption = 'CFO No.';
            TableRelation = Employee;
        }
        field(50003; "Financial Controller Email"; Text[80])
        {
            CalcFormula = Lookup(Employee."E-Mail" WHERE("No." = FIELD("Financial Controller No.")));
            Caption = 'Financial Controller Email';
            Editable = false;
            ExtendedDatatype = EMail;
            FieldClass = FlowField;
        }
        field(50004; "Cost Controller Email"; Text[80])
        {
            CalcFormula = Lookup(Employee."E-Mail" WHERE("No." = FIELD("Cost Controller No.")));
            Caption = 'Cost Controller Email';
            Editable = false;
            ExtendedDatatype = EMail;
            FieldClass = FlowField;
        }
        field(50005; "CFO Email"; Text[80])
        {
            CalcFormula = Lookup(Employee."E-Mail" WHERE("No." = FIELD("CFO No.")));
            Caption = 'CFO Email';
            Editable = false;
            ExtendedDatatype = EMail;
            FieldClass = FlowField;
        }
    }
}
