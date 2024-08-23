Class careia.utils.Test Extends %RegisteredObject
{

ClassMethod chunk() [ Language = python ]
{
from transformers import AutoTokenizer

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
text = (
    "Ceci est un exemple de texte que nous allons découper en chunks basés sur le nombre de tokens. "
    "Le tokenizer utilisé ici est basé sur RoBERTa, ce qui garantit une compatibilité optimale avec ce modèle. "
    "Chaque chunk aura une taille maximale en tokens, avec un chevauchement facultatif entre les chunks."
)

# Paramètres de chunking
max_tokens = 50        # Taille maximale d'un chunk en tokens
overlap_tokens = 10    # Chevauchement entre les chunks en tokens (facultatif)

# Découper le texte en chunks
chunks = chunk_text_by_tokens(text, tokenizer, max_tokens, overlap_tokens)

# Afficher les chunks
for i, chunk in enumerate(chunks):
    print(f"Chunk {i+1}: {chunk}\n")
}

}
