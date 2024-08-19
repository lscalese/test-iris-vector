Class careia.bs.PutPatientDataBS Extends Ens.BusinessService
{

Parameter ADAPTER;

Parameter TARGETBP = "careia.bp.PutPatientDataBP";

Method OnProcessInput(pInput As careia.messages.requests.PatientEmbeddingRQ, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
    Set sc = $$$OK
    
    Set sc = ..SendRequestAsync(..#TARGETBP, pInput, "Send async request to add patient data vector")

    Set pOutput = ##class(careia.messages.ReturnMSG).%New()

    Set pOutput.status = $Select($$$ISERR(sc):"ERROR",1:"OK")

    If $$$ISERR(sc) {
        Set pOutput.message = $SYSTEM.Status.GetErrorText(sc)
    } Else {
        Set pOutput.message = "Patient data added to the queue successfully"
    }
    

    Return sc
}

}
