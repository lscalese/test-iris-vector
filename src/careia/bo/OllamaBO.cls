Class careia.bo.OllamaBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Parameter SETTINGS = "OllamaModel";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Property OllamaModel As %String [ InitialExpression = "mistral" ];

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
        if $IsObject($Get(pHttpResponse)) {
            $$$LOGINFO(pHttpResponse.Data.Read())
        }
        Return sc
    }

    #dim pHttpResponse As %Net.HttpResponse
    #dim json As %DynamicObject
    
    If pHttpResponse.StatusCode = "200" {
        Set json = {}.%FromJSON(pHttpResponse.Data)
        Set formatterJSON = ##class(%JSON.Formatter).%New()
        Do formatterJSON.FormatToString(json, .formattedJSON)
        $$$LOGINFO(formattedJSON)
        Set responseMessage = ##class(careia.messages.VectorResponseMSG).%New()
        Set responseMessage.embedding = responseMessage.embeddingDisplayToLogical(json.embeddings.%Get(0))
    }

	Return sc
}

/// Implement operationId : apiembeddingsPOST
/// post /api/embeddings
Method generatePOST(requestMessage As careia.messages.requests.OllamaGenerateRQ, Output responseMessage As careia.messages.responses.OllamaGenerateRSP) As %Status
{
	Set sc = $$$OK
   
	Set pHttpRequestIn = ##class(%Net.HttpRequest).%New()
    Set pHttpRequestIn.ContentType = "application/json"
    Do pHttpRequestIn.SetHeader("accept", "application/json")
    
    Set str = ""

    Set model = $Select(requestMessage.model = "": ..OllamaModel, 1:requestMessage.model)

    Set body = {
        "model" :(model),
        "prompt" :(requestMessage.prompt),
        "stream" : false
    }

    Do body.%ToJSON(pHttpRequestIn.EntityBody)

	Set sc = ..Adapter.SendFormDataArray(.pHttpResponse, "post", pHttpRequestIn, , , ..Adapter.URL _ "/api/generate")

    If $$$ISERR(sc) {
        If $IsObject($Get(pHttpResponse)) {
            $$$LOGINFO(pHttpResponse.Data.Read())
        }
        Return sc
    }

    #dim pHttpResponse As %Net.HttpResponse
    #dim json As %DynamicObject
    
    If pHttpResponse.StatusCode = "200" {
        Set json = {}.%FromJSON(pHttpResponse.Data)
        
        Set formatter = ##class(%JSON.Formatter).%New()
        Do formatter.FormatToString(json, .formattedJSON)
        $$$LOGINFO(json.%ToJSON())

        Set responseMessage = ##class(careia.messages.responses.OllamaGenerateRSP).%New()
        Set responseMessage.response = json.response
        Set responseMessage.model = json.model
        Set responseMessage.context = responseMessage.contextDisplayToLogical(json.context)
    }

	Return sc
}

Method chatPOST(requestMessage As careia.messages.requests.OllamaChatRQ, Output responseMessage As careia.messages.responses.OllamaChatRSP) As %Status
{
	Set sc = $$$OK
   
	Set pHttpRequestIn = ##class(%Net.HttpRequest).%New()
    Set pHttpRequestIn.ContentType = "application/json"
    Do pHttpRequestIn.SetHeader("accept", "application/json")
    
    Set str = ""

    Set model = $Select(requestMessage.model = "": ..OllamaModel, 1:requestMessage.model)

    Set body = {
        "model" :(model),
        "messages" :({}.%FromJSON(requestMessage.messages)),
        "stream" : false
    }

    Do body.%ToJSON(pHttpRequestIn.EntityBody)

	Set sc = ..Adapter.SendFormDataArray(.pHttpResponse, "post", pHttpRequestIn, , , ..Adapter.URL _ "/api/chat")

    If $$$ISERR(sc) {
        If $IsObject($Get(pHttpResponse)) {
            $$$LOGINFO(pHttpResponse.Data.Read())
        }
        Return sc
    }

    #dim pHttpResponse As %Net.HttpResponse
    #dim json As %DynamicObject
    
    If pHttpResponse.StatusCode = "200" {
        Set json = {}.%FromJSON(pHttpResponse.Data)
        
        Set formatter = ##class(%JSON.Formatter).%New()
        Do formatter.FormatToString(json, .formattedJSON)
        $$$LOGINFO(json.%ToJSON())

        Set responseMessage = ##class(careia.messages.responses.OllamaChatRSP).%New()
        Do responseMessage.message.Clear()
        Do responseMessage.message.Write(formattedJSON)
        
    }

	Return sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringContainer">
		<Method>embeddingsPOST</Method>
	</MapItem>
	<MapItem MessageType="careia.messages.requests.OllamaGenerateRQ">
		<Method>generatePOST</Method>
	</MapItem>
	<MapItem MessageType="careia.messages.requests.OllamaChatRQ">
		<Method>chatPOST</Method>
	</MapItem>
</MapItems>
}

}
