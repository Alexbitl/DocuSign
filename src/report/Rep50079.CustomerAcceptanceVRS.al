/// <summary>
/// 
/// #DocuSign
/// </summary>
report 50079 "CustomerAcceptanceVRS"
{
    RDLCLayout = './Customer Acceptance Form.rdlc';

    Caption = 'Customer Acceptance Form';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoLbl)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoLbl)
            {
            }
            column(CompanyBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameLbl)
            {
            }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyInfo.FIELDCAPTION("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoLbl)
            {
            }
            column(CompanyIBAN; CompanyInfo.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyInfo.FIELDCAPTION(IBAN))
            {
            }
            column(CompanySWIFT; CompanyInfo."SWIFT Code")
            {
            }
            column(CompanySWIFT_Lbl; CompanyInfo.FIELDCAPTION("SWIFT Code"))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber)
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyLegalOffice; CompanyInfo.GetLegalOffice)
            {
            }
            column(CompanyLegalOffice_Lbl; CompanyInfo.GetLegalOfficeLbl)
            {
            }
            column(CompanyCustomGiro; CompanyInfo.GetCustomGiro)
            {
            }
            column(CompanyCustomGiro_Lbl; CompanyInfo.GetCustomGiroLbl)
            {
            }
            column(CompanyLegalStatement; GetLegalStatement)
            {
            }
            column(CustomerAddress1; CustAddr[1])
            {
            }
            column(CustomerAddress2; CustAddr[2])
            {
            }
            column(CustomerAddress3; CustAddr[3])
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustAddr[5])
            {
            }
            column(CustomerAddress6; CustAddr[6])
            {
                AutoFormatType = 2;
            }
            column(CustomerAddress7; CustAddr[7])
            {
            }
            column(CustomerAddress8; CustAddr[8])
            {
            }
            column(CustomerAddress9; CustAddr[9])
            {
            }
            column(CustomerAddress10; CustAddr[10])
            {
            }
            column(CustomerAddress11; CustAddr[11])
            {
            }
            column(CustomerAddress12; CustAddr[12])
            {
            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(ExternalDocumentNo; Header."External Document No.")
            {
                Description = 'ExternalDocumentNo';
            }
            column(YourReference_Lbl; FIELDCAPTION("Your Reference"))
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(ShipmentMethodDescription_Lbl; ShptMethodDescLbl)
            {
            }
            column(Shipment_Lbl; ShipmentLbl)
            {
            }
            column(ShipmentDate; FORMAT("Shipment Date", 0, 4))
            {
            }
            column(ShipmentDate_Lbl; FIELDCAPTION("Shipment Date"))
            {
            }
            column(ShowShippingAddress; ShowShippingAddr)
            {
            }
            column(ShipToAddress_Lbl; ShiptoAddrLbl)
            {
            }
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentTermsDescription_Lbl; PaymentTermsDescLbl)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PaymentMethodDescription_Lbl; PaymentMethodDescLbl)
            {
            }
            column(DocumentCopyText; STRSUBSTNO(DocumentCaption, CopyText))
            {
            }
            column(BilltoCustumerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoCustomerNo_Lbl; FIELDCAPTION("Bill-to Customer No."))
            {
            }
            column(DocumentDate; FORMAT("Document Date", 0, 1))
            {
            }
            column(DocumentDate_Lbl; FIELDCAPTION("Document Date"))
            {
            }
            column(DueDate; FORMAT("Due Date", 0, 1))
            {
            }
            column(DueDate_Lbl; FIELDCAPTION("Due Date"))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentNo_Lbl; InvNoLbl)
            {
            }
            column(QuoteNo; "Quote No.")
            {
            }
            column(QuoteNo_Lbl; FIELDCAPTION("Quote No."))
            {
            }
            column(PricesIncludingVAT; "Prices Including VAT")
            {
            }
            column(PricesIncludingVAT_Lbl; FIELDCAPTION("Prices Including VAT"))
            {
            }
            column(PricesIncludingVATYesNo; FORMAT("Prices Including VAT"))
            {
            }
            column(SalesPerson_Lbl; SalespersonLbl)
            {
            }
            column(SalesPersonText_Lbl; SalesPersonText)
            {
            }
            column(SalesPersonName; SalesPersonName)
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerNo_Lbl; FIELDCAPTION("Sell-to Customer No."))
            {
            }
            column(VATRegistrationNo; GetCustomerVATRegistrationNumber)
            {
            }
            column(VATRegistrationNo_Lbl; GetCustomerVATRegistrationNumberLbl)
            {
            }
            column(GlobalLocationNumber; GetCustomerGlobalLocationNumber)
            {
            }
            column(GlobalLocationNumber_Lbl; GetCustomerGlobalLocationNumberLbl)
            {
            }
            column(LegalEntityType; Cust.GetLegalEntityType)
            {
            }
            column(LegalEntityType_Lbl; Cust.GetLegalEntityTypeLbl)
            {
            }
            column(Copy_Lbl; CopyLbl)
            {
            }
            column(EMail_Lbl; EMailLbl)
            {
            }
            column(HomePage_Lbl; HomePageLbl)
            {
            }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl)
            {
            }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl)
            {
            }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl)
            {
            }
            column(LocalCurrency_Lbl; LocalCurrencyLbl)
            {
            }
            column(ExchangeRateAsText; ExchangeRateText)
            {
            }
            column(Page_Lbl; PageLbl)
            {
            }
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl)
            {
            }
            column(Invoice_Lbl; SalesConfirmationLbl)
            {
            }
            column(Subtotal_Lbl; SubtotalLbl)
            {
            }
            column(Total_Lbl; TotalLbl)
            {
            }
            column(VATAmount_Lbl; VATAmtLbl)
            {
            }
            column(VATBase_Lbl; VATBaseLbl)
            {
            }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl)
            {
            }
            column(VATClauses_Lbl; VATClausesLbl)
            {
            }
            column(VATIdentifier_Lbl; VATIdentifierLbl)
            {
            }
            column(VATPercentage_Lbl; VATPercentageLbl)
            {
            }
            column(VATClause_Lbl; VATClause.TABLECAPTION)
            {
            }
            // column(PeriodCovered; "Period Covered")
            // {
            // }
            column(PostingDate; FORMAT(Header."Posting Date", 0, 1))
            {
            }
            column(TopText; TopText)
            {
            }
            column(DownText; DownText)
            {
            }
            column(ProjectCompleteText; ProjectCompleteText)
            {
            }
            column(ProjectNotCompleteText; ProjectNotCompleteText)
            {
            }
            column(CaptionReportText; CaptionReport)
            {
            }
            column(FooterText; FooterText)
            {
            }
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    ORDER(Ascending);
                UseTemporary = true;
                column(LineNo_Line; "Line No.")
                {
                }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(AmountExcludingVAT_Line_Lbl; FIELDCAPTION(Amount))
                {
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(AmountIncludingVAT_Line_Lbl; FIELDCAPTION("Amount Including VAT"))
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Description_Line; LineDesc)
                {
                }
                column(Description_Line_Lbl; FIELDCAPTION(Description))
                {
                }
                column(LineDiscountPercent_Line; "Line Discount %")
                {
                }
                column(LineDiscountPercentText_Line; LineDiscountPctText)
                {
                }
                column(LineAmount_Line; "Line Amount")
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(LineAmount_Line_Lbl; FIELDCAPTION("Line Amount"))
                {
                }
                column(ItemNo_Line; "No.")
                {
                }
                column(ItemNo_Line_Lbl; FIELDCAPTION("No."))
                {
                }
                column(ShipmentDate_Line; FORMAT(PostedShipmentDate))
                {
                }
                column(ShipmentDate_Line_Lbl; PostedShipmentDateLbl)
                {
                }
                column(Quantity_Line; Quantity)
                {
                }
                column(Quantity_Line_Lbl; FIELDCAPTION(Quantity))
                {
                }
                column(QtytoShip_Line; QtytoShipText)
                {
                }
                column(Type_Line; FORMAT(Type))
                {
                }
                column(UnitPrice; "Unit Price")
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(UnitPrice_Lbl; FIELDCAPTION("Unit Price"))
                {
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                }
                column(UnitOfMeasure_Lbl; FIELDCAPTION("Unit of Measure"))
                {
                }
                column(VATIdentifier_Line; "VAT Identifier")
                {
                }
                column(VATIdentifier_Line_Lbl; FIELDCAPTION("VAT Identifier"))
                {
                }
                column(VATPct_Line; "VAT %")
                {
                }
                column(VATPct_Line_Lbl; FIELDCAPTION("VAT %"))
                {
                }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(CrossReferenceNo; "Cross-Reference No.")
                {
                }
                column(CrossReferenceNo_Lbl; FIELDCAPTION("Cross-Reference No."))
                {
                }
                dataitem(AssemblyLine; "Assembly Line")
                {
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    column(LineNo_AssemblyLine; "No.")
                    {
                    }
                    column(Description_AssemblyLine; Description)
                    {
                    }
                    column(Quantity_AssemblyLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code"))
                    {
                        // DecimalPlaces = 0 : 5;
                    }
                    column(VariantCode_AssemblyLine; "Variant Code")
                    {
                        // DecimalPlaces = 0 : 5;
                    }

                    trigger OnPreDataItem()
                    begin
                        IF NOT DisplayAssemblyInformation THEN
                            CurrReport.BREAK;
                        IF NOT AsmInfoExistsForLine THEN
                            CurrReport.BREAK;
                        SETRANGE("Document Type", AsmHeader."Document Type");
                        SETRANGE("Document No.", AsmHeader."No.");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    Currency: Record Currency;
                    SalesLine2: Record "Sales Line";
                    Resource: Record Resource;
                begin
                    PostedShipmentDate := 0D;

                    IF Type = Type::"G/L Account" THEN
                        "No." := '';

                    IF "Line Discount %" = 0 THEN
                        LineDiscountPctText := ''
                    ELSE
                        LineDiscountPctText := STRSUBSTNO('%1%', -ROUND("Line Discount %", 0.1));

                    IF DisplayAssemblyInformation THEN
                        AsmInfoExistsForLine := AsmToOrderExists(AsmHeader);

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := "Line Amount";
                    TotalSubTotal += "Line Amount";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                    IF FirstLineHasBeenOutput THEN
                        CLEAR(CompanyInfo.Picture);
                    FirstLineHasBeenOutput := TRUE;

                    LineDesc := ''; //Line."Extended Description";
                    // IF Line."Extended Description" = '' THEN
                    //     LineDesc := Line.Description + ' ' + Line."Description 2";

                    IF Resource.GET("No.") THEN
                        IF COPYSTR(Resource.Name, 1, 5) = 'Tieto' THEN
                            LineDesc := ''; //Description + ' Lot ' + "No." + ' - ' + "Extended Description";

                    IF UPPERCASE(Line."Unit of Measure") <> 'FIXCOST' THEN
                        LineDesc += ', ' + Line."Unit of Measure"
                    ELSE BEGIN
                        IF Header."Currency Code" = '' THEN
                            Currency.GET('USD')
                        ELSE
                            Currency.GET(Header."Currency Code");
                        IF Currency.Symbol <> '' THEN
                            LineDesc += ', ' + Currency.Symbol
                        ELSE
                            LineDesc += ', ' + Currency.Code;

                    END;

                    // IF CIF AND ("Customer Line Code" <> '') THEN
                    //     LineDesc := 'Line ' + "Customer Line Code" + ' - ' + LineDesc;

                    QtytoShipText := FORMAT(Line."Qty. to Ship", 0, '<Precision,2:2><Sign><Integer><Decimals><comma,.>');
                end;

                trigger OnPreDataItem()
                begin
                    MoreLines := FIND('+');
                    WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                        MoreLines := NEXT(-1) <> 0;
                    IF NOT MoreLines THEN
                        CurrReport.BREAK;
                    SETRANGE("Line No.", 0, "Line No.");
                    CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                    FirstLineHasBeenOutput := FALSE;
                    CompanyInfo.CALCFIELDS(Picture);
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code");//, "Use Tax, Positive");
                UseTemporary = true;
                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FIELDCAPTION("Invoice Discount Amount"))
                {
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FIELDCAPTION("Inv. Disc. Base Amount"))
                {
                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FIELDCAPTION("Line Amount"))
                {
                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FIELDCAPTION("VAT Amount"))
                {
                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl)
                {
                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FIELDCAPTION("VAT Base"))
                {
                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl)
                {
                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {
                }
                column(VATIdentifier_VatAmountLine_Lbl; FIELDCAPTION("VAT Identifier"))
                {
                }
                column(VATPct_VatAmountLine; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATPct_VatAmountLine_Lbl; FIELDCAPTION("VAT %"))
                {
                }
                column(NoOfVATIdentifiers; COUNT)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY :=
                      GetBaseLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");
                    VATAmountLCY :=
                      GetAmountLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;

                    // IF "VAT Clause Code" <> '' THEN BEGIN
                    //     VATClauseLine := VATAmountLine;
                    //     IF VATClauseLine.INSERT THEN;
                    // END;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS(
                      "Line Amount", "Inv. Disc. Base Amount",
                      "Invoice Discount Amount", "VAT Base", "VAT Amount",
                      VATBaseLCY, VATAmountLCY);

                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;

                    VATClauseLine.DELETEALL;
                end;
            }
            dataitem(VATClauseLine; "VAT Clause")
            {
                UseTemporary = true;
                // column(VATIdentifier_VATClauseLine; "VAT Identifier")
                // {
                // }
                column(Code_VATClauseLine; VATClause.Code)
                {
                }
                column(Code_VATClauseLine_Lbl; VATClause.FIELDCAPTION(Code))
                {
                }
                column(Description_VATClauseLine; VATClause.Description)
                {
                }
                column(Description2_VATClauseLine; VATClause."Description 2")
                {
                }
                // column(VATAmount_VATClauseLine; "VAT Amount")
                // {
                //     AutoFormatExpression = Header."Currency Code";
                //     AutoFormatType = 1;
                // }
                column(NoOfVATClauses; COUNT)
                {
                }

                // trigger OnAfterGetRecord()
                // begin
                //     IF "VAT Clause Code" = '' THEN
                //         CurrReport.SKIP;
                //     IF NOT VATClause.GET("VAT Clause Code") THEN
                //         CurrReport.SKIP;
                //     VATClause.TranslateDescription(Header."Language Code");
                // end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = SORTING("Line No.");
                UseTemporary = true;
                column(Description_ReportTotalsLine; Description)
                {
                }
                column(Amount_ReportTotalsLine; Amount)
                {
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {
                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {
                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {
                }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines;
                end;
            }
            dataitem(LetterText; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
                column(PmtDiscText; PmtDiscText)
                {
                }

                trigger OnPreDataItem()
                begin
                    PmtDiscText := '';
                    IF Header."Payment Discount %" <> 0 THEN
                        PmtDiscText := STRSUBSTNO(PmtDiscTxt, Header."Pmt. Discount Date", Header."Payment Discount %");
                end;
            }
            dataitem(Totals; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(TotalNetAmount; TotalAmount)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(TotalVATBaseLCY; TotalVATBaseLCY)
                {
                }
                column(TotalAmountIncludingVAT; TotalAmountInclVAT)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(TotalVATAmount; TotalAmountVAT)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(TotalVATAmountLCY; TotalVATAmountLCY)
                {
                }
                column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalVATAmountText; VATAmountLine.VATAmountText)
                {
                }
                column(TotalExcludingVATText; TotalExclVATText)
                {
                }
                column(TotalIncludingVATText; TotalInclVATText)
                {
                }
                column(TotalSubTotal; TotalSubTotal)
                {
                    AutoFormatExpression = '<Precision,2:2><Sign><Integer><Decimals><comma,.>';
                }
                column(TotalSubTotalMinusInvoiceDiscount; TotalSubTotal + TotalInvDiscAmount)
                {
                }
                column(TotalText; TotalText)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                ShipToAddrL: Record "Ship-to Address";
                SellToCustomerL: Record Customer;
                ArchiveManagement: Codeunit ArchiveManagement;
                SalesPost: Codeunit 80;
                Contact: Record 5050;
                i: Integer;
                SalesLine: Record "Sales Line";
                j: Integer;
                ContactName: array[3] of Text[50];
                ii: Integer;
                text001: Label '                  %1';
                ch: Char;
            begin
                CLEAR(Line);
                CLEAR(SalesPost);

                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", Header."Document Type");
                SalesLine.SETRANGE("Document No.", Header."No.");
                SalesLine.SETFILTER("Qty. to Ship", '<>0');
                // IF SalesLine.FINDSET THEN
                //     REPEAT
                //         Line.SETRANGE("Extended Description", SalesLine."Extended Description");
                //         IF Line.FIND('-') THEN BEGIN
                //             Line."Qty. to Ship" += SalesLine."Qty. to Ship";
                //             Line.MODIFY;
                //         END
                //         ELSE BEGIN
                //             Line.COPY(SalesLine);
                //             Line.INSERT;
                //         END;


                //     UNTIL SalesLine.NEXT = 0;


                IF NOT CurrReport.PREVIEW THEN
                    CODEUNIT.RUN(CODEUNIT::"Sales-Printed", Header);

                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);

                SellToCustomerL.GET(Header."Sell-to Customer No.");
                FormatAddr.Customer(CustAddr, SellToCustomerL);

                // IF Header."CAF Ship-to" = '' THEN BEGIN
                //     ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, Header);

                //     CustAddr[1] := SellToCustomerL.Name + SellToCustomerL."Name 2";//."Full Name";
                //     IF SellToCustomerL."Name 2" <> '' THEN
                //         CustAddr[2] := '';
                //     COMPRESSARRAY(CustAddr);
                //     j := 0;
                //     ch := 13;
                //     IF Header."Sell-to Contact No. 2" <> '' THEN BEGIN
                //         j += 1;
                //         Contact.GET(Header."Sell-to Contact No. 2");
                //         i := 1;
                //         WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                //         IF i < 12 THEN
                //             IF j = 1 THEN
                //                 CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                //             ELSE
                //                 CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");

                //         ContactName[j] := Header."Sell-to Contact 2";
                //     END;

                //     IF Header."Sell-to Contact No. 3" <> '' THEN BEGIN
                //         j += 1;
                //         Contact.GET(Header."Sell-to Contact No. 3");
                //         i := 1;
                //         WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                //         IF i < 12 THEN
                //             IF j = 1 THEN
                //                 CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                //             ELSE
                //                 CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");

                //         ContactName[j] := Header."Sell-to Contact 3";
                //     END;

                //     IF Header."Sell-to Contact No. 4" <> '' THEN BEGIN
                //         j += 1;
                //         Contact.GET(Header."Sell-to Contact No. 4");
                //         i := 1;
                //         WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                //         IF i < 12 THEN
                //             IF j = 1 THEN
                //                 CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                //             ELSE
                //                 CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");

                //         ContactName[j] := Header."Sell-to Contact 4";
                //     END;

                //     FOR ii := i DOWNTO 2 DO BEGIN CustAddr[ii + j] := CustAddr[ii]; END;
                //     FOR i := 2 TO 1 + j DO CustAddr[i] := ContactName[i - 1];
                // END
                // ELSE BEGIN
                //     CLEAR(CustAddr);
                //     // FormatAddr.SalesCAFAddress(CustAddr, Header);
                //     // COMPRESSARRAY(CustAddr);
                //     // j := 0;
                //     // ch := 13;
                //     // IF Header."Sell-to Contact No. 2" <> '' THEN BEGIN
                //     //     j += 1;
                //     //     Contact.GET(Header."Sell-to Contact No. 2");
                //     //     i := 1;
                //     //     WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                //     //     IF i < 12 THEN
                //     //         IF j = 1 THEN
                //     //             CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                //     //         ELSE
                //     //             CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");
                //     // END;

                // //     IF Header."Sell-to Contact No. 3" <> '' THEN BEGIN
                // //         j += 1;
                // //         Contact.GET(Header."Sell-to Contact No. 3");
                // //         i := 1;
                // //         WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                // //         IF i < 12 THEN
                // //             IF j = 1 THEN
                // //                 CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                // //             ELSE
                // //                 CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");
                // //     END;

                // //     IF Header."Sell-to Contact No. 4" <> '' THEN BEGIN
                // //         j += 1;
                // //         Contact.GET(Header."Sell-to Contact No. 4");
                // //         i := 1;
                // //         WHILE (CustAddr[i] <> '') AND (i < 12) DO i += 1;
                // //         IF i < 12 THEN
                // //             IF j = 1 THEN
                // //                 CustAddr[i] := STRSUBSTNO('E-Mail: %1', Contact."E-Mail")
                // //             ELSE
                // //                 CustAddr[i] := STRSUBSTNO(text001, Contact."E-Mail");
                // //     END;
                // // END;

                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);

                IF "Currency Code" <> '' THEN BEGIN
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    CalculatedExchRate :=
                      ROUND(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := STRSUBSTNO(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                END;

                FormatDocumentFields(Header);

                IF NOT CurrReport.PREVIEW AND
                   (CurrReport.USEREQUESTPAGE AND ArchiveDocument OR
                    NOT CurrReport.USEREQUESTPAGE AND SalesSetup."Archive Quotes and Orders")
                THEN
                    ArchiveManagement.StoreSalesDocument(Header, LogInteraction);

                IF LogInteraction AND NOT CurrReport.PREVIEW THEN BEGIN
                    CALCFIELDS("No. of Archived Versions");
                    IF "Bill-to Contact No." <> '' THEN
                        SegManagement.LogDocument(
                          3, "No.", "Doc. No. Occurrence",
                          "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No."
                          , "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                    ELSE
                        SegManagement.LogDocument(
                          3, "No.", "Doc. No. Occurrence",
                          "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.",
                          "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                END;

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

                //mc.kma 05.24.17 >>
                IF SalespersonPurchaser."E-Mail 2" = '' THEN
                    SalesPersonName := SalespersonPurchaser."E-Mail"
                ELSE
                    SalesPersonName := SalespersonPurchaser."E-Mail" + ';' + SalespersonPurchaser."E-Mail 2";
                SalesPersonName := SalespersonPurchaser.Name + ' (' + SalesPersonName + ')';
                IF CIF THEN BEGIN
                    TopText := TopText2;
                    DownText := DownText2;
                    CaptionReport := CaptionReport2;
                END
                ELSE BEGIN
                    TopText := TopText1;
                    DownText := DownText1;
                    CaptionReport := CaptionReport1;
                END;
                //mc.kma 05.24.17 <<

                //mc.kma 05.29.17 >>
                IF ProjectComplete THEN BEGIN
                    ProjectCompleteText := 'X';
                    ProjectNotCompleteText := '';
                END
                ELSE BEGIN
                    ProjectCompleteText := '';
                    ProjectNotCompleteText := 'X';
                END;

                //mc.kma 05.29.17 <<

            end;

            trigger OnPreDataItem()
            begin
                FirstLineHasBeenOutput := FALSE;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';

                        trigger OnValidate()
                        begin
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(CustomerInvoiceForm; CIF)
                    {
                        Caption = 'Customer Invoice Form';
                        Description = 'Customer Invoice Form';
                    }
                    field("Project is complete"; ProjectComplete)
                    {
                        Caption = 'Project is complete';
                    }
                    field(FooterText; FooterText)
                    {
                        Caption = 'Footer Text';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            ArchiveDocument := SalesSetup."Archive Quotes and Orders";
            FooterText := 'Recorded Shortfalls of the Final Project Outcome (if any):';
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;
        CompanyInfo.VerifyAndSetPaymentInfo;
    end;

    trigger OnPreReport()
    begin
        IF Header.GETFILTERS = '' THEN
            ERROR(NoFilterSetErr);

        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";

        IF FooterText = '' THEN
            FooterText := 'Recorded Shortfalls of the Final Project Outcome (if any):';
    end;

    var
        SalesConfirmationLbl: Label 'Order Confirmation';
        SalespersonLbl: Label 'Sales person';
        CompanyInfoBankAccNoLbl: Label 'Account No.';
        CompanyInfoBankNameLbl: Label 'Bank';
        CompanyInfoGiroNoLbl: Label 'Giro No.';
        CompanyInfoPhoneNoLbl: Label 'Phone No.';
        CopyLbl: Label 'Copy';
        EMailLbl: Label 'Email';
        HomePageLbl: Label 'Home Page';
        InvDiscBaseAmtLbl: Label 'Invoice Discount Base Amount';
        InvDiscountAmtLbl: Label 'Invoice Discount';
        InvNoLbl: Label 'Order No.';
        LineAmtAfterInvDiscLbl: Label 'Payment Discount on VAT';
        LocalCurrencyLbl: Label 'Local Currency';
        PageLbl: Label 'Page';
        PaymentTermsDescLbl: Label 'Payment Terms';
        PaymentMethodDescLbl: Label 'Payment Method';
        PostedShipmentDateLbl: Label 'Shipment Date';
        SalesInvLineDiscLbl: Label 'Discount %';
        ShipmentLbl: Label 'Shipment';
        ShiptoAddrLbl: Label 'Ship-to Address';
        ShptMethodDescLbl: Label 'Shipment Method';
        SubtotalLbl: Label 'Subtotal';
        TotalLbl: Label 'Total';
        VATAmtSpecificationLbl: Label 'VAT Amount Specification';
        VATAmtLbl: Label 'VAT Amount';
        VATAmountLCYLbl: Label 'VAT Amount (LCY)';
        VATBaseLbl: Label 'VAT Base';
        VATBaseLCYLbl: Label 'VAT Base (LCY)';
        VATClausesLbl: Label 'VAT Clause';
        VATIdentifierLbl: Label 'VAT Identifier';
        VATPercentageLbl: Label 'VAT %';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        VATClause: Record "VAT Clause";
        AsmHeader: Record "Assembly Header";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        PostedShipmentDate: Date;
        CustAddr: array[12] of Text[250];
        ShipToAddr: array[8] of Text[250];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        MoreLines: Boolean;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        CompanyLogoPosition: Integer;
        FirstLineHasBeenOutput: Boolean;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        PmtDiscTxt: Label 'If we receive the payment before %1, you are eligible for a 2% payment discount.', Comment = '%1 Discount Due Date %2 = value of Payment Discount % ';
        BodyLbl: Label 'Thank you for your business. Your order confirmation is attached to this message.';
        PmtDiscText: Text;
        LineDesc: Text;
        SalesPersonName: Text;
        TopText: Text;
        DownText: Text;
        TopText1: Label 'This document is used to obtain the customer''s acceptance: ';
        TopText2: Label 'This document is used to obtain the customer''s confirmation of the number of hours of Services performed by. Contractor in the Period Covered in accordance with the Contract for Services Agreement and associated.              Statement of Work.';
        DownText1: TextConst;
        DownText2: Label 'CONTRACTOR AGREES THAT MITEL''S ACKNOWLEDGEMENT OF THE NUMBER OF HOURS OF SERVICES PERFORMED IN THE PERIOD COVERED ABOVE IS NOT IN ITSELF ACCEPTANCE OF THE SERVICES AND DELIVERABLES DELIVERED DURING SUCH PERIOD. THE ACCEPTANCE PROCESS FOR SUCH IS AS OUTLINED IN THE APPLICABLE SOW.';
        CIF: Boolean;
        ProjectComplete: Boolean;
        ProjectCompleteText: Text;
        ProjectNotCompleteText: Text;
        ShipQtySum: Decimal;
        ClearFlag: Boolean;
        QtytoShipText: Text;
        CaptionReport1: Label 'Customer Acceptance Form';
        CaptionReport2: Label 'Customer Invoice Form';
        CaptionReport: Text;
        FooterText: Text;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        EXIT(SalesConfirmationLbl);
    end;

    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        WITH SalesHeader DO BEGIN
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetSalesPerson(SalespersonPurchaser, "Salesperson Code", SalesPersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            //FormatDocument.SetPaymentMethod(PaymentMethod, "Payment Method Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
        END;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DELETEALL;
        IF (TotalInvDiscAmount <> 0) OR (TotalAmountVAT <> 0) THEN
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, TRUE, FALSE, FALSE);
        IF TotalInvDiscAmount <> 0 THEN BEGIN
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, FALSE, FALSE, FALSE);
            IF TotalAmountVAT <> 0 THEN
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, TRUE, FALSE, FALSE);
        END;
        IF TotalAmountVAT <> 0 THEN
            ReportTotalsLine.Add(VATAmountLine.VATAmountText, TotalAmountVAT, FALSE, TRUE, FALSE);
    end;

    procedure SetInitParameters(CIFP: Boolean; ProjectCompleteP: Boolean; FooterTextP: Text)
    begin
        CIF := CIFP;
        ProjectComplete := ProjectCompleteP;
        FooterText := FooterTextP;
    end;
}

