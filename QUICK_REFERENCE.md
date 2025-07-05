# 🚀 PostgresAI - Quick Reference Card

**📁 Documentation Location**: `/Volumes/NASté-DockerHD/Users Guides/PostgresAI/`  
**🏠 Project Location**: `/Volumes/NASté-DockerHD/Applications/Mac/Docker/_:Docker Projects (Active)/Projects/PostgresAI/`

> **📋 For detailed setup instructions:** See [`USER_GUIDE.md`](/Volumes/NASté-DockerHD/Users Guides/PostgresAI/USER_GUIDE.md)

## 📍 **Essential URLs**

```text
TinyBERT Health:  http://localhost:8083/health
TinyBERT Models:  http://localhost:8083/models
TinyBERT Embed:   http://localhost:8083/embed (POST)
TinyBERT Similar: http://localhost:8083/similarity (POST)
PgAdmin:          http://localhost:5051
PostgreSQL:       localhost:65432
DBeaver:          localhost:65432 (use PostgreSQL driver)
```

## ⚡ **Quick Commands**
```bash
# Navigate to project directory first
cd "/Volumes/NASté-DockerHD/Applications/Mac/Docker/_:Docker Projects (Active)/Projects/PostgresAI"

# Start services
docker compose up -d

# Stop services  
docker compose down

# Check status
docker compose ps

# View logs
docker compose logs tinybert

# Test API
curl http://localhost:8083/health

# Check available models
curl http://localhost:8083/models
```

## 🔧 **Database Connection**
```bash
# Command line
psql -h localhost -p 65432 -U postgres -d postgres_ai

# From container
docker exec -it postgres_ai psql -U postgres -d postgres_ai

# DBeaver connection settings:
# Host: localhost
# Port: 65432
# Database: postgres_ai
# Username: postgres
# Password: postgres123
```

## 🧠 **TinyBERT API Examples**
```bash
# Check model info (shows if model is loaded)
curl http://localhost:8083/models

# Load model by making first embedding request
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello world"}'

# Text embedding (after model loads)
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text":"Your text here"}'

# Text similarity comparison
curl -X POST http://localhost:8083/similarity \
  -H "Content-Type: application/json" \
  -d '{"text1":"Hello", "text2":"Hi"}'
```

> **📝 Note**: Model loads automatically on first use. Initial requests may take longer while downloading the DistilBERT model.

## 🛠️ **Troubleshooting**
```bash
# Check if model is loaded
curl http://localhost:8083/health
# Look for "model_loaded": true/false

# Force model loading (first request may take 30-60 seconds)
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text":"test"}'

# Rebuild container if model loading fails
docker compose build --no-cache tinybert
docker compose up -d tinybert

# Check detailed logs for errors
docker logs tinybert_ai

# Clean up Docker resources
docker system prune -f
```

## 📚 **Additional Resources**
```bash
# Test all services
/Volumes/NASté-DockerHD/Users Guides/PostgresAI/test_services.sh

# Complete documentation
/Volumes/NASté-DockerHD/Users Guides/PostgresAI/USER_GUIDE.md

# All user guides index
/Volumes/NASté-DockerHD/Users Guides/PostgresAI/README.md
```

---
**📍 Location**: `/Volumes/NASté-DockerHD/Users Guides/PostgresAI/`  
**🏗️ Project**: `/Volumes/NASté-DockerHD/Applications/Mac/Docker/_:Docker Projects (Active)/Projects/PostgresAI/`  
*Complete PostgresAI setup with Docker services, TinyBERT AI, PostgreSQL database, and comprehensive tooling*
