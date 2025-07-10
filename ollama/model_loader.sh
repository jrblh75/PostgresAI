#!/bin/bash

# Model loader script for Ollama
echo "Loading Ollama models for PostgresAI..."

# Check if models directory exists
if [ ! -d "/app/models" ]; then
    mkdir -p /app/models
fi

# Function to download and load model with error handling
load_model() {
    local model_name=$1
    local description=$2
    echo "Loading model: $model_name ($description)"
    
    if ollama pull "$model_name"; then
        echo "✓ Successfully loaded: $model_name"
        # Test the model
        if ollama run "$model_name" "Hello" >/dev/null 2>&1; then
            echo "✓ Model test successful: $model_name"
        else
            echo "⚠️ Model test failed for: $model_name"
        fi
    else
        echo "⚠️ Failed to load model: $model_name"
    fi
}

# Load default models
load_model "llama3" "Meta's Llama 3 - Default model"

# Check environment variable for additional models
if [ -n "$ADDITIONAL_MODELS" ]; then
    for model in $(echo $ADDITIONAL_MODELS | tr ',' ' '); do
        load_model "$model" "Additional requested model"
    done
fi

echo "Model loading complete"
exit 0
