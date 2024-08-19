Class careia.bp.PutPatientDataBP Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As careia.messages.requests.PatientEmbeddingRQ, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    #dim pVectorResponse As careia.messages.VectorResponseMSG

    Set sc = ..StoreDocument(pRequest.document)

    If $$$ISERR(sc) {
        Return sc
    }

    /// split document into chunks

    #dim chunks As %DynamicArray

    Set chunks = ..SplitDocument(pRequest.document)

    #dim iter As %Iterator.Array = chunks.%GetIterator()

    While iter.%GetNext(.key, .value) {
        Set sc = ..GetVector(value, .pVectorResponse)
        
        Quit:$$$ISERR(sc)

        Set storeEmbeddingRequest = ##class(careia.messages.PutPatientEmbedding).%New()
        Set storeEmbeddingRequest.patientId = pRequest.patientId
        Set storeEmbeddingRequest.type = pRequest.type
        Set storeEmbeddingRequest.embedding = pVectorResponse.embedding
        $$$LOGINFO("embedding: "_pVectorResponse.embedding)
        Set storeEmbeddingRequest.chunk = value

        Set sc = ..SendRequestSync("careia.bo.StorePatientEmbedding", .storeEmbeddingRequest, .pResponse, 15)
    }

    Return sc
}

Method GetVector(text As %String, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{

    Set sc = $$$OK

    Set stringContainer = ##class(Ens.StringContainer).%New()
    Set stringContainer.StringValue = text

    Set sc = ..SendRequestSync("EmbeddingProcess", stringContainer, .pResponse, 30)

    Return sc
}

Method StoreDocument(tStream As %Stream.GlobalCharacter, Output documentId As %Integer) As %Status
{
    Set sc = $$$OK
    Set documentId = ""

    Do tStream.Rewind()

    Set pRequest = ##class(Ens.StreamContainer).%New()
    Set pRequest.Stream = ##class(%Stream.GlobalCharacter).%New()
    Do pRequest.Stream.CopyFrom(tStream)

    Set sc = ..SendRequestSync("careia.bo.StorePatientEmbedding", pRequest, .pResponse, 15)
    
    If $$$ISERR(sc) {
        Return sc
    }

    Set documentId = {}.%FromJSON(pResponse.body).id

    Return sc
}

ClassMethod SplitDocument(stream As %Stream.GlobalCharacter) As %DynamicArray [ Language = python ]
{

import iris
from langchain.text_splitter import RecursiveCharacterTextSplitter

documentStr = ""

while stream.AtEnd==0:
    documentStr += stream.Read(32000)

splitter = RecursiveCharacterTextSplitter(chunk_size=1024, chunk_overlap=100)

chunks = splitter.split_text(documentStr)

del documentStr

irisArray = iris.cls("%DynamicArray")._New()

for chunk in chunks:
    irisArray._Push(chunk)

del chunks, chunk

return irisArray
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
