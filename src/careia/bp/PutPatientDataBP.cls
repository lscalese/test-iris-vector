Class careia.bp.PutPatientDataBP Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As careia.messages.PutPatientDataMSG, Output pResponse As %Persistent) As %Status
{
    #dim pVectorResponse As careia.messages.VectorResponseMSG

    Set sc = ..GetVector(pRequest, .pVectorResponse)

    If $$$ISERR(sc) Return sc

    Set storeEmbeddingRequest = ##class(careia.messages.PutPatientEmbedding).%New()
    Set storeEmbeddingRequest.patientId = pRequest.patientId
    Set storeEmbeddingRequest.type = pRequest.type
    Set storeEmbeddingRequest.embedding = pVectorResponse.embedding

    Set sc = ..SendRequestSync("careia.bo.StorePatientEmbedding", .storeEmbeddingRequest, .pResponse, 120)

    Return sc
}

Method GetVector(pRequest As careia.messages.PutPatientDataMSG, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    Set sc = $$$OK

    $$$LOGINFO("PutPatientDataBP:GetVector")

    ;Set sc = ..SendRequestSync("careia.bo.EmbeddingBO", .pRequest, .pResponse, 15)

    Set stringContainer = ##class(Ens.StringContainer).%New()
    Set stringContainer.StringValue = pRequest.sentences.GetAt(1)

    Set sc = ..SendRequestSync("careia.bo.OllamaBO", .stringContainer, .pResponse, 15)
    
    Return sc
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
