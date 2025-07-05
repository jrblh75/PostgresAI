#!/bin/bash

# Model loader script for Ollama
echo "Loading Ollama models..."

# Check if models directory exists
if [ ! -d "/app/models" ]; then
    mkdir -p /app/models
fi

# Function to download and load model
load_model() {
    local model_name=$1
    echo "Loading model: $model_name"
    ollama pull $model_name
    if [ $? -eq 0 ]; then
        echo "Successfully loaded: $model_name"
    else
        echo "Failed to load: $model_name"
    fi
}

# Load default models
load_model "deepseek:latest"
load_model "llama2:13b-chat-q4_0"

echo "Model loading complete!"
