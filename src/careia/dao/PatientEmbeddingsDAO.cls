Class careia.dao.PatientEmbeddingsDAO
{

ClassMethod StoreEmbedding(patientId As %Integer, type As %String, embedding As %Vector) As %Status
{
    Set sc = $$$OK

    If ##class(careia.data.PatientEmbeddings).UniqueIExists(patientId, type, .id) {
        Set patientEmbeddings = ##class(careia.data.PatientEmbeddings).%OpenId(id)

        

    } Else {
        Set patientEmbeddings = ##class(careia.data.PatientEmbeddings).%New()


    }
    
    Set patientEmbeddings.patientId = patientId
    ;Set patientEmbeddings.embedding = patientEmbeddings.embeddingDisplayToLogical(embedding)
    Set patientEmbeddings.embedding = embedding
    Set patientEmbeddings.type = type
    Set sc = patientEmbeddings.%Save()
    Return sc
}

}
