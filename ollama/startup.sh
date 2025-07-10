#!/bin/bash

echo "Starting Ollama service..."

# Start the Ollama server in the background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama to start up
echo "Waiting for Ollama server to start..."
sleep 10

# Load models
/app/model_loader.sh

# Keep the container running
echo "Ollama server is running with PID: $OLLAMA_PID"
wait $OLLAMA_PID
