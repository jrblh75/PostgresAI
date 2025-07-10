FROM ollama/ollama:latest

# Create directories
RUN mkdir -p /app/models

# Copy startup scripts
COPY startup.sh /app/startup.sh
COPY model_loader.sh /app/model_loader.sh

# Set execute permissions
RUN chmod +x /app/startup.sh /app/model_loader.sh

# Set working directory
WORKDIR /app

# Default command
CMD ["/app/startup.sh"]
