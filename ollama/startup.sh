#!/bin/bash

# Start Ollama in background
ollama serve &

# Wait for Ollama to be ready
echo "Waiting for Ollama to start..."
while ! curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 2
done

echo "Ollama is ready! Loading models..."

# Pull deepseek model
echo "Pulling deepseek:latest model..."
ollama pull deepseek:latest

# Pull llama2 13b quantized model
echo "Pulling llama2:13b-chat-q4_0 model..."
ollama pull llama2:13b-chat-q4_0

echo "All models loaded successfully!"

# Keep container running
wait
