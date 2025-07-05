# 🚀 PostgresAI - Quick Reference Card

## 📍 **Essential URLs**
```
TinyBERT API:    http://localhost:8083
Health Check:    http://localhost:8083/health
PgAdmin:         http://localhost:5051
PostgreSQL:      localhost:65432
```

## ⚡ **Quick Commands**
```bash
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
```

## 🔧 **Database Connection**
```bash
# Command line
psql -h localhost -p 65432 -U postgres -d postgres_ai

# From container
docker exec -it postgres_ai psql -U postgres -d postgres_ai
```

## 🧠 **TinyBERT API Examples**
```bash
# Text embedding
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text":"Your text here"}'

# Text similarity
curl -X POST http://localhost:8083/similarity \
  -H "Content-Type: application/json" \
  -d '{"text1":"Hello", "text2":"Hi"}'
```

## 🛠️ **Troubleshooting**
```bash
# Rebuild container
docker compose build --no-cache tinybert
docker compose up -d tinybert

# Check logs
docker logs tinybert_ai

# Clean up
docker system prune -f
```

---
*Quick access to all PostgresAI commands and URLs*
