Class careia.bo.OllamaBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Parameter SETTINGS = "OllamaModel";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Property OllamaModel As %String [ InitialExpression = "orca-mini" ];

/// Implement operationId : apiembeddingsPOST
/// post /api/embeddings
Method embeddingsPOST(requestMessage As Ens.StringContainer, Output responseMessage As careia.messages.VectorResponseMSG) As %Status
{
	Set sc = $$$OK
   
	Set pHttpRequestIn = ##class(%Net.HttpRequest).%New()
    Set pHttpRequestIn.ContentType = "application/json"
    Do pHttpRequestIn.SetHeader("accept", "application/json")
    
    Set str = ""

    Set body = {
        "model" :(..OllamaModel),
        "input" :(requestMessage.StringValue)
    }

    Do body.%ToJSON(pHttpRequestIn.EntityBody)

	Set sc = ..Adapter.SendFormDataArray(.pHttpResponse, "post", pHttpRequestIn, , , ..Adapter.URL _ "/api/embed")

    If $$$ISERR(sc) {
        $$$LOGINFO(pHttpResponse.Data.Read())
        Return sc
    }

    #dim pHttpResponse As %Net.HttpResponse
    #dim json As %DynamicObject
    
    If pHttpResponse.StatusCode = "200" {
        Set json = {}.%FromJSON(pHttpResponse.Data)
        $$$LOGINFO(json.%ToJSON())
        Set responseMessage = ##class(careia.messages.VectorResponseMSG).%New()
        Set responseMessage.embedding = responseMessage.embeddingDisplayToLogical(json.embeddings.%Get(0))
    }

	Return sc
}

/*
Method generatePOST(requestMessage As careia.ollama.requests.apigeneratePOST, Output responseMessage As careia.ollama.responses.apigeneratePOST) As %Status
{
	Set sc = $$$OK, pHttpRequestIn = ##class(%Net.HttpRequest).%New(), responseMessage = ##class(careia.ollama.responses.apigeneratePOST).%New()
	$$$QuitOnError(requestMessage.LoadHttpRequestObject(pHttpRequestIn))
	$$$QuitOnError(..Adapter.SendFormDataArray(.pHttpResponse, "post", pHttpRequestIn, , , ..Adapter.URL_requestMessage.%URL))
	$$$QuitOnError(responseMessage.LoadFromResponse(pHttpResponse, "apigeneratePOST"))
	Quit sc
}*/
/// Implement operationId : apigeneratePOST
/// post /api/generate
/// 
XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringContainer">
		<Method>embeddingsPOST</Method>
	</MapItem>
	<!--<MapItem MessageType="careia.ollama.requests.apigeneratePOST">
		<Method>generatePOST</Method>
	</MapItem>-->
</MapItems>
}

}
