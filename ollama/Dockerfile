FROM ollama/ollama:latest

# Install curl and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create model directory
RUN mkdir -p /app/models

# Copy model loader script
COPY model_loader.sh /app/model_loader.sh
RUN chmod +x /app/model_loader.sh

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_PORT=11434

# Expose port
EXPOSE 11434

# Create startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Start ollama and load models
CMD ["/startup.sh"]
