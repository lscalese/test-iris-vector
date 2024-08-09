Class careia.bs.PutPatientDataBS Extends Ens.BusinessService
{

Parameter ADAPTER;

Parameter TARGETBP = "careia.bp.PutPatientDataBP";

Method OnProcessInput(pInput As careia.rest.model.putPatientDatabody, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
    Set sc = $$$OK
    set pOutput = { "responseText" : "Hello world!" }

    Set request = ##class(careia.messages.PutPatientDataMSG).%New()
    Set request.patientId = pInput.patientId
    Set request.sentences = pInput.sentences
    Set request.type = pInput.type

    Set sc = ..SendRequestAsync(..#TARGETBP, request, "Send async request to add patient data vector")

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
