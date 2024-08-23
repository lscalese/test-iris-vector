Class careia.bo.StorePatientEmbedding Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
    Set sc = $$$OK

    Return sc
}

Method StorePatientEmbedding(pRequest As careia.messages.PutPatientEmbedding, Output pResponse As careia.messages.ReturnMSG) As %Status
{
    Set sc = $$$OK

    $$$LOGINFO(pRequest.embedding)

    Set dto = {
        "patientId": (pRequest.patientId),
        "type": (pRequest.type),
        "embedding": (pRequest.embeddingLogicalToDisplay(pRequest.embedding)),
        "chunk": (pRequest.chunk),
        "sourceId": (pRequest.sourceId)
    }
    
    Set sc = ##class(careia.dao.PatientEmbeddingsDAO).StoreEmbeddingByDTO(dto)
    
    Set pResponse = ##class(careia.messages.ReturnMSG).%New()
    Set pResponse.status = $Select($$$ISERR(sc):"ERROR", 1:"OK")
    Set pResponse.message = $Select($$$ISERR(sc):$SYSTEM.Status.GetErrorText(sc), 1:"Embedding stored successfully")

    Return sc
}

Method StoreDocument(pRequest As Ens.StreamContainer, Output pResponse As careia.messages.ReturnMSG) As %Status
{
    Set id = ""
    
    Set pResponse = ##class(careia.messages.ReturnMSG).%New()

    Set sc = ##class(careia.dao.PatientEmbeddingsDAO).StoreSource(pRequest.Stream, .id, .exists)

    Set pResponse.status = $Select($$$ISERR(sc):"ERROR", 1:"OK")
    Set pResponse.message = $Select($$$ISERR(sc):$SYSTEM.Status.GetErrorText(sc), 1:$Select(exists:"Document already exists", 1:"Document stored successfully"))
    Do pResponse.body.Write({"id":(id)}.%ToJSON())

    Return sc
}

XData MessageMap
{
<MapItems>
        <MapItem MessageType="careia.messages.PutPatientEmbedding">
            <Method>StorePatientEmbedding</Method>
        </MapItem>
        <MapItem MessageType="Ens.StreamContainer">
            <Method>StoreDocument</Method>
        </MapItem>
    </MapItems>
}

}
