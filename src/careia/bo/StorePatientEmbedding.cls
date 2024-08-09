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

    Set sc = ##class(careia.dao.PatientEmbeddingsDAO).StoreEmbedding(pRequest.patientId, pRequest.type, pRequest.embedding)
    
    Set pResponse = ##class(careia.messages.ReturnMSG).%New()
    Set pResponse.status = $Select($$$ISERR(sc):"ERROR", 1:"OK")
    Set pResponse.message = $Select($$$ISERR(sc):$SYSTEM.Status.GetErrorText(sc), 1:"Embedding stored successfully")

    Return sc
}

XData MessageMap
{
<MapItems>
        <MapItem MessageType="careia.messages.PutPatientEmbedding">
            <Method>StorePatientEmbedding</Method>
        </MapItem>
    </MapItems>
}

}
