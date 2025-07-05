# PostgresAI - Easy User Guide 🚀

## Quick Start URLs & Addresses

### 🌐 Web Interfaces
| Service | URL | Description |
|---------|-----|-------------|
| **TinyBERT API** | `http://localhost:8083` | AI/ML Text Processing |
| **TinyBERT Health** | `http://localhost:8083/health` | Service Status Check |
| **PgAdmin** | `http://localhost:5051` | Database Management UI |
| **DBeaver** | `http://localhost:8978` | Database Browser |
| **Open WebUI** | `http://localhost:3000` | Chat Interface |

### 🗄️ Database Connections
| Service | Host | Port | Database | Username |
|---------|------|------|----------|----------|
| **PostgreSQL** | `localhost` | `65432` | `postgres_ai` | `postgres` |

---

## 🐳 Essential Docker Commands

### Start/Stop Services
```bash
# Start all services
docker compose up -d

# Start specific services only
docker compose up -d postgres tinybert pgadmin

# Stop all services
docker compose down

# Restart services
docker compose restart
```

### Service Management
```bash
# View running containers
docker compose ps

# Check service logs
docker compose logs tinybert
docker compose logs postgres
docker compose logs -f tinybert  # Follow logs

# Check container health
docker ps
```

### Build & Rebuild
```bash
# Build specific service
docker compose build tinybert

# Rebuild and restart
docker compose up -d --build tinybert

# Force rebuild (no cache)
docker compose build --no-cache tinybert
```

---

## 🧠 TinyBERT API Usage

### Health Check
```bash
curl http://localhost:8083/health
```

### Text Embedding
```bash
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello, world!"}'
```

### Text Similarity
```bash
curl -X POST http://localhost:8083/similarity \
  -H "Content-Type: application/json" \
  -d '{"text1":"Hello world", "text2":"Hi there"}'
```

### List Models
```bash
curl http://localhost:8083/models
```

---

## 🗄️ Database Connection Guide

### Using psql (Command Line)
```bash
# Connect from host machine
psql -h localhost -p 65432 -U postgres -d postgres_ai

# Connect from within Docker network
docker exec -it postgres_ai psql -U postgres -d postgres_ai
```

### PgAdmin Web Interface
1. Open: `http://localhost:5051`
2. Login with credentials from `.env` file
3. Add server:
   - **Host**: `postgres_ai` (container name)
   - **Port**: `5432` (internal port)
   - **Database**: `postgres_ai`
   - **Username**: `postgres`

---

## 🛠️ Troubleshooting Commands

### Check Container Status
```bash
# View all containers
docker ps -a

# Check specific container logs
docker logs tinybert_ai
docker logs postgres_ai

# Execute commands inside container
docker exec -it tinybert_ai bash
docker exec -it postgres_ai bash
```

### Network & Connectivity
```bash
# Test TinyBERT service
curl -f http://localhost:8083/health

# Test PostgreSQL
docker exec postgres_ai pg_isready -U postgres

# Check Docker networks
docker network ls
docker network inspect postgresai_postgres_ai_network
```

### Storage & Cleanup
```bash
# Check disk usage
docker system df

# Clean up unused resources
docker system prune -f
docker image prune -f
docker volume prune -f

# Remove specific container
docker rm container_name
```

---

## 📁 Project Structure

```
PostgresAI/
├── docker-compose.yml      # Main service configuration
├── .env                    # Environment variables
├── tinybert/
│   ├── Dockerfile         # TinyBERT container config
│   ├── app/main.py        # Flask application
│   └── requirements.txt   # Python dependencies
├── db/
│   └── init/              # Database initialization
├── ollama/                # LLM service
└── docs/                  # Documentation
```

---

## 🔧 Configuration Files

### Environment Variables (.env)
```bash
# Database Configuration
POSTGRES_DB=postgres_ai
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password

# TinyBERT Configuration
MODEL_NAME=distilbert-base-uncased
FLASK_ENV=production

# Ports
POSTGRES_PORT=65432
TINYBERT_PORT=8083
PGADMIN_PORT=5051
```

---

## 🚨 Common Issues & Solutions

### Issue: Container won't start
```bash
# Check logs for errors
docker compose logs service_name

# Rebuild container
docker compose build --no-cache service_name
docker compose up -d service_name
```

### Issue: Port already in use
```bash
# Find process using port
lsof -i :8083

# Kill process or change port in docker-compose.yml
```

### Issue: TinyBERT model not loading
```bash
# Check available disk space
df -h

# Check model download progress
docker logs tinybert_ai -f

# Clear model cache and restart
docker compose down
docker volume rm postgresai_tinybert_models
docker compose up -d tinybert
```

---

## 📚 API Examples

### Python Example
```python
import requests

# Health check
response = requests.get('http://localhost:8083/health')
print(response.json())

# Get text embedding
data = {"text": "Machine learning is awesome!"}
response = requests.post('http://localhost:8083/embed', json=data)
embeddings = response.json()['embeddings']
```

### JavaScript Example
```javascript
// Health check
fetch('http://localhost:8083/health')
  .then(response => response.json())
  .then(data => console.log(data));

// Text similarity
const payload = {
  text1: "Hello world",
  text2: "Hi there"
};

fetch('http://localhost:8083/similarity', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(payload)
})
.then(response => response.json())
.then(data => console.log('Similarity:', data.similarity));
```

---

## 🔄 Quick Reference

### Daily Operations
```bash
# Morning startup
docker compose up -d

# Check everything is running
docker compose ps
curl http://localhost:8083/health

# Evening shutdown
docker compose down
```

### Development Workflow
```bash
# Make changes to code
# Rebuild and restart
docker compose build tinybert
docker compose up -d tinybert

# Test changes
curl http://localhost:8083/health
```

---

## 📞 Support & Resources

- **GitHub Repository**: https://github.com/jrblh75/PostgresAI
- **Project Location**: `/Volumes/NASté-DockerHD/Applications/Mac/Docker/_:Docker Projects (Active)/Projects/PostgresAI`
- **Docker Documentation**: https://docs.docker.com/
- **Flask Documentation**: https://flask.palletsprojects.com/

---

*Last Updated: July 4, 2025*
*Version: 1.0*
