/// <summary>
/// 
/// #DocuSign
/// </summary>
codeunit 50022 "DocuSignStatusUpdateVRS"
{
    trigger OnRun()
    begin
        StartUpdate;
    end;

    local procedure StartUpdate()
    var
        EnvelopeL: Record DocuSignEnvelopeVRS;
        DocuSignMgtL: Codeunit DocuSignManagementVRS;
    begin
        EnvelopeL.SETCURRENTKEY(Status);
        EnvelopeL.SETFILTER(Status, '<%1', EnvelopeL.Status::"Signed by Both Parties");
        IF EnvelopeL.FINDSET(TRUE, FALSE) THEN
            REPEAT
                //DocuSignMgtL.SetJobQueueStarted(TRUE);
                DocuSignMgtL.UpdateOneEnvelopeStatus(EnvelopeL);
                DocuSignMgtL.UpdateEnvelopeOverdueSigning(EnvelopeL);
            UNTIL EnvelopeL.NEXT = 0;
    end;
}

