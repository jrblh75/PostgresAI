#!/bin/bash

# PostgresAI Docker Services - Port Listing Script
# This script shows all ports used by the PostgresAI Docker stack

echo "=================================="
echo "PostgresAI Docker Stack - Port Usage"
echo "=================================="
echo "Date: $(date)"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please run this script from the PostgresAI directory."
    exit 1
fi

echo "📊 Configured Port Mappings:"
echo "───────────────────────────────────────────────────────────────"
echo "Service         | External Port | Internal Port | Status"
echo "───────────────────────────────────────────────────────────────"

# Function to check if port is in use
check_port() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1; then
        echo "🟢 ACTIVE"
    else
        echo "🔴 INACTIVE"
    fi
}

# PostgreSQL
echo "PostgreSQL      |     65432     |     5432      | $(check_port 65432)"

# pgAdmin
echo "pgAdmin         |     5051      |      80       | $(check_port 5051)"

# DBeaver CloudBeaver
echo "DBeaver         |     8978      |     8978      | $(check_port 8978)"

# OpenWebUI
echo "OpenWebUI       |     8081      |     8080      | $(check_port 8081)"

# Ollama API
echo "Ollama API      |     11434     |     11434     | $(check_port 11434)"

# TinyBERT
echo "TinyBERT        |     8083      |     8083      | $(check_port 8083)"

# Nginx HTTP
echo "Nginx HTTP      |      80       |      80       | $(check_port 80)"

# Nginx HTTPS
echo "Nginx HTTPS     |     443       |     443       | $(check_port 443)"

echo "───────────────────────────────────────────────────────────────"
echo ""

# Show detailed port usage with lsof
echo "🔍 Detailed Port Usage (lsof):"
echo "───────────────────────────────────────────────────────────────"

ports=(65432 5051 8978 8081 11434 8083 80 443)

for port in "${ports[@]}"; do
    echo ""
    echo "Port $port:"
    lsof_output=$(lsof -i :$port 2>/dev/null)
    if [ -n "$lsof_output" ]; then
        echo "$lsof_output"
    else
        echo "  No processes listening on port $port"
    fi
done

echo ""
echo "🐳 Docker Container Status:"
echo "───────────────────────────────────────────────────────────────"
if docker-compose ps >/dev/null 2>&1; then
    docker-compose ps
else
    echo "No Docker Compose services found or not running"
fi

echo ""
echo "🌐 Network Information:"
echo "───────────────────────────────────────────────────────────────"
echo "Docker Network: postgres_ai_postgres_ai_network"
echo "Subnet: 172.20.0.0/16"

# Check if network exists
if docker network ls | grep -q "postgres_ai_postgres_ai_network"; then
    echo "✅ Network exists"
    docker network inspect postgres_ai_postgres_ai_network | grep -A 5 "IPAM"
else
    echo "❌ Network not found"
fi

echo ""
echo "📁 Volume Usage:"
echo "───────────────────────────────────────────────────────────────"
volumes=("postgres_data" "pg_data" "pgadmin_data" "dbeaver_data" "open-webui-data" "ollama_data" "ollama_model_loader_data" "ollama_loader" "tinybert_models" "tailscale_data" "nginx_logs")

for volume in "${volumes[@]}"; do
    if docker volume ls | grep -q "$volume"; then
        size=$(docker system df -v | grep "$volume" | awk '{print $3}' || echo "Unknown")
        echo "✅ $volume - Size: $size"
    else
        echo "❌ $volume - Not found"
    fi
done

echo ""
echo "🔧 Useful Commands:"
echo "───────────────────────────────────────────────────────────────"
echo "Start all services:     docker-compose up -d"
echo "Stop all services:      docker-compose down"
echo "View logs:              docker-compose logs -f"
echo "Check service status:   docker-compose ps"
echo "Restart service:        docker-compose restart <service-name>"
echo ""
echo "🌍 Access URLs:"
echo "───────────────────────────────────────────────────────────────"
echo "pgAdmin:                http://localhost:5051"
echo "OpenWebUI:              http://localhost:8081"
echo "DBeaver:                http://localhost:8978"
echo "TinyBERT API:           http://localhost:8083"
echo "Ollama API:             http://localhost:11434"
echo ""
echo "🔒 HTTPS URLs (with SSL):"
echo "───────────────────────────────────────────────────────────────"
echo "pgAdmin:                https://pgadmin.localhost"
echo "OpenWebUI:              https://webui.localhost"
echo "TinyBERT API:           https://tinybert.localhost"
echo "Ollama API:             https://ollama.localhost"
echo ""
echo "=================================="
