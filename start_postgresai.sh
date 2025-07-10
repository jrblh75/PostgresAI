#!/bin/bash

# PostgresAI Startup Script
# This script starts the entire PostgresAI stack

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting PostgresAI Stack...${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo -e "${GREEN}📁 Loading environment variables from .env file...${NC}"
    source .env
fi

# Create postgresql.conf if it doesn't exist
if [ ! -f ./db/postgresql.conf ]; then
    echo -e "${YELLOW}⚠️ Creating default postgresql.conf...${NC}"
    cat > ./db/postgresql.conf << EOL
# PostgreSQL configuration file
listen_addresses = '*'
max_connections = 100
shared_buffers = 128MB
dynamic_shared_memory_type = posix
max_wal_size = 1GB
min_wal_size = 80MB
log_timezone = 'UTC'
datestyle = 'iso, mdy'
timezone = 'UTC'
lc_messages = 'en_US.UTF-8'
lc_monetary = 'en_US.UTF-8'
lc_numeric = 'en_US.UTF-8'
lc_time = 'en_US.UTF-8'
default_text_search_config = 'pg_catalog.english'
password_encryption = 'scram-sha-256'
EOL
fi

# Start the Docker Compose stack
echo -e "${GREEN}🐳 Starting Docker Compose stack...${NC}"
docker-compose up -d

# Check if services are running
echo -e "${BLUE}🔍 Checking if services are running...${NC}"
sleep 5

if [ "$(docker ps -q -f name=postgresai_db)" ]; then
    echo -e "${GREEN}✅ PostgreSQL is running${NC}"
else
    echo -e "${RED}❌ PostgreSQL failed to start${NC}"
    docker-compose logs postgres
    exit 1
fi

if [ "$(docker ps -q -f name=postgresai_nginx)" ]; then
    echo -e "${GREEN}✅ Nginx is running${NC}"
else
    echo -e "${RED}❌ Nginx failed to start${NC}"
    docker-compose logs nginx
    exit 1
fi

if [ "$(docker ps -q -f name=postgresai_ollama)" ]; then
    echo -e "${GREEN}✅ Ollama is running${NC}"
else
    echo -e "${RED}❌ Ollama failed to start${NC}"
    docker-compose logs ollama
    exit 1
fi

echo -e "${GREEN}🎉 PostgresAI Stack started successfully!${NC}"
echo -e "${BLUE}📊 Database: localhost:5432${NC}"
echo -e "${BLUE}🌐 Web UI: https://localhost:8443${NC}"

exit 0
