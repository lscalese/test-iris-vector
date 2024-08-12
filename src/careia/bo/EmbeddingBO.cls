Class careia.bo.EmbeddingBO Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
    Set sc = $$$OK

    Return sc
}

Method GetEmbeddingForPatient(pRequest As careia.messages.PutPatientDataMSG, Output pResponse As careia.messages.VectorResponseMSG) As %Status
{
    Set sc = $$$OK

    $$$LOGINFO("EmbeddingBO:GetEmbeddingForPatient")

    Set pResponse = ##class(careia.messages.VectorResponseMSG).%New()

    Set str = pRequest.sentences.GetAt(1)

    Set pResponse.embedding = pResponse.embeddingDisplayToLogical(..GetEmbeddingPy(str))

    Return sc
}

ClassMethod GetEmbeddingPy(sentences) As %DynamicArray [ Language = python ]
{
import json
import iris

# import the package
import sentence_transformers

# create the model and form the embeddings
# LSC:
# Vérifier sur https://sbert.net/docs/sentence_transformer/pretrained_models.html
# si un autre modèle ne serait pas plus adapté pour le français.
model = sentence_transformers.SentenceTransformer('all-MiniLM-L6-v2')

embeddings = model.encode(sentences)

# convert the embeddings to a string
# code de la doc qui ne marche pas :
#   embeddings_list = [str(embedding.tolist()) for embedding in embeddings]
#   return embeddings_list

irisArray = iris.cls("%DynamicArray")._New()

for embedding in embeddings:
    irisArray._Push(str(embedding.tolist()))

return irisArray
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="careia.messages.PutPatientDataMSG">
        <Method>GetEmbeddingForPatient</Method>
    </MapItem>
</MapItems>
}

}
