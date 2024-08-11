Class careia.bs.Chat Extends Ens.BusinessService
{

Method OnProcessInput(pInput As careia.messages.requests.OllamaChatRQ, Output pOutput As careia.messages.responses.OllamaChatRSP, ByRef pHint As %String) As %Status
{
    Set sc = $$$OK
    
    Set sc = ..SendRequestSync("careia.bo.OllamaBO", .pInput, .pOutput, 30)

    Return sc
}

}
