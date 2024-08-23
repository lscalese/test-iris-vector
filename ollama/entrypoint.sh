#!/bin/sh

./bin/ollama serve &
./bin/ollama pull $MODEL
./bin/ollama pull $EMBEDDINGMODEL


ollama run $MODEL

tail -f /dev/null