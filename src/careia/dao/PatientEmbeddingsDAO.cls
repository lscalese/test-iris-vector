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

/// La structure de dto doit être la suite : 
/// {
///   "patientId": 1,
///   "embedding": [0.1, 0.2, 0.3],
///   "type": "type",
///   "chunk": "chunk",
///   "sourceId": "source"
/// }
ClassMethod StoreEmbeddingByDTO(dto As %DynamicObject) As %Status
{

    Set sc = $$$OK

    Set tempStream = ##class(%Stream.GlobalCharacter).%New()
    Do tempStream.Write(dto.chunk)
    Set hash = $System.Encryption.Base64Encode(##class(%SYSTEM.Encryption).SHAHashStream(256, tempStream))
    Kill tempStream

    If ##class(careia.data.PatientEmbeddings).uniqueIExists(dto.patientId, hash, .id) {
        Set patientEmbeddings = ##class(careia.data.PatientEmbeddings).%OpenId(id)
    } Else {
        Set patientEmbeddings = ##class(careia.data.PatientEmbeddings).%New()
        Set patientEmbeddings.hash = hash
        Set patientEmbeddings.patientId = dto.patientId
        Set patientEmbeddings.chunk = dto.chunk
    }

    Set patientEmbeddings.embedding = patientEmbeddings.embeddingDisplayToLogical(dto.embedding)
    Set patientEmbeddings.type = dto.type
    Do patientEmbeddings.sourceSetObjectId(dto.sourceId)

    Return patientEmbeddings.%Save()
}

ClassMethod StoreSource(document As %Stream.GlobalCharacter, Output id As %Integer = "", exists As %Boolean = 0) As %Status
{
    Set hash = $System.Encryption.Base64Encode(##class(%SYSTEM.Encryption).SHAHashStream(256, document))

    If ##class(careia.data.Source).hashIExists(hash, .id) {
        Set exists = $$$YES    
        Return $$$OK
    }

    Set source = ##class(careia.data.Source).%New()
    Do source.text.CopyFromAndSave(document)
    Set source.hash = hash

    Set sc = source.%Save()
    Set id = source.%Id()

    Return sc
}

}
