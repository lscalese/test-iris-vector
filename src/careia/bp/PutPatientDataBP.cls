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

ClassMethod SplitChar(stream As %Stream.GlobalCharacter) As %DynamicArray [ Language = python ]
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

ClassMethod SplitDocument(stream As %Stream.GlobalCharacter) As %DynamicArray [ Language = python ]
{

from transformers import AutoTokenizer
import iris

def chunk_text_by_tokens(text, tokenizer, max_tokens, overlap_tokens=0):
    # Tokeniser le texte
    tokens = tokenizer(text, return_tensors='pt', truncation=False, add_special_tokens=False)['input_ids'][0]

    # Découper en chunks en respectant la taille maximale des tokens
    chunks = []
    for i in range(0, len(tokens), max_tokens - overlap_tokens):
        chunk = tokens[i:i + max_tokens]
        print(chunk)
        chunks.append(tokenizer.decode(chunk, skip_special_tokens=True))

    return chunks

# Charger le tokenizer RoBERTa
#model_name = "roberta-large"
model_name = "mixedbread-ai/mxbai-embed-large-v1"

tokenizer = AutoTokenizer.from_pretrained(model_name)

# Exemple de texte
# text = (
#    "Ceci est un exemple de texte que nous allons découper en chunks basés sur le nombre de tokens. "
#    "Le tokenizer utilisé ici est basé sur RoBERTa, ce qui garantit une compatibilité optimale avec ce modèle. "
#    "Chaque chunk aura une taille maximale en tokens, avec un chevauchement facultatif entre les chunks."
#)

text = ""

while stream.AtEnd==0:
    text += stream.Read(32000)

# Paramètres de chunking
max_tokens = 384        # Taille maximale d'un chunk en tokens
overlap_tokens = 75     # Chevauchement entre les chunks en tokens (facultatif)

# Découper le texte en chunks
chunks = chunk_text_by_tokens(text, tokenizer, max_tokens, overlap_tokens)

# Afficher les chunks
# for i, chunk in enumerate(chunks):
#    print(f"Chunk {i+1}: {chunk}\n")

irisArray = iris.cls("%DynamicArray")._New()
for chunk in enumerate(chunks):
    irisArray._Push(chunk)

return irisArray
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
