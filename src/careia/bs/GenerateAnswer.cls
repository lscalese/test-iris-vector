Class careia.bs.GenerateAnswer Extends Ens.BusinessService
{

Parameter ADAPTER;

Method OnProcessInput(pInput As careia.messages.requests.OllamaGenerateRQ, Output pOutput As careia.messages.responses.OllamaGenerateRSP, ByRef pHint As %String) As %Status
{
    Set sc = $$$OK
    
    Set sc = ..SendRequestSync("OllamaRESTOperation", .pInput, .pOutput, 30)

    Return sc
}

}
