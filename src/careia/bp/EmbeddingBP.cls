Class careia.bp.EmbeddingBP Extends Ens.BusinessProcess
{

Parameter OLLAMABO = "OllamaRESTOperation";

Parameter SENTENCETRANSFORMERBO = "SentenceTransformer";

Parameter SETTINGS = "TargetVectorBuilder";

Property TargetVectorBuilder As %String(CAPTION = "Vector builder") [ InitialExpression = {..#OLLAMABO} ];

Method OnRequest(pRequest As Ens.StringContainer, Output pVectorResponse As careia.messages.VectorResponseMSG) As %Status
{
    Return ..GetVector(pRequest.StringValue, .pVectorResponse)
}

Method GetVector(tSentence As %String, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    Set sc = $$$OK

    If ..TargetVectorBuilder = ..#OLLAMABO {
        $$$LOGINFO("Using Ollama")
        Set sc = ..GetVectorByOllama(tSentence, .pResponse)
    } ElseIf ..TargetVectorBuilder = ..#SENTENCETRANSFORMERBO {
        $$$LOGINFO("Using SentenceTransformer")
        Set sc = ..GetVectorBySentenceTransformer(tSentence, .pResponse)
    } Else {
        $$$LOGINFO("Invalid TargetVectorBuilder: "_..TargetVectorBuilder)
        Set sc = $$$ERROR($$$GeneralError, "Invalid TargetVectorBuilder: "_..TargetVectorBuilder)
    }
    
    Return sc
}

Method GetVectorByOllama(tSentence As %String, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    Set sc = $$$OK

    Set stringContainer = ##class(Ens.StringContainer).%New()
    Set stringContainer.StringValue = tSentence

    Set pResponse = ##class(careia.messages.VectorResponseMSG).%New()

    Set sc = ..SendRequestSync(..#OLLAMABO, .stringContainer, .pResponse, 15)
    
    Return sc
}

Method GetVectorBySentenceTransformer(tSentence As %String, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    Set sc = $$$OK

    Set stringContainer = ##class(Ens.StringContainer).%New()
    Set stringContainer.StringValue = tSentence

    Set pResponse = ##class(careia.messages.VectorResponseMSG).%New()

    Set sc = ..SendRequestSync(..#SENTENCETRANSFORMERBO, .stringContainer, .pResponse, 15)
    
    Return sc
}

Storage Default
{
<Data name="EmbeddingBPDefaultData">
<Subscript>"EmbeddingBP"</Subscript>
<Value name="1">
<Value>TargetVectorBuilder</Value>
</Value>
</Data>
<DefaultData>EmbeddingBPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
