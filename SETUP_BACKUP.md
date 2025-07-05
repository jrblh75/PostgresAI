# PostgresAI Docker Setup - Complete Backup

## Project Structure
```
PostgresAI/
├── docker-compose.yml
├── .env
├── check_ports.sh
├── SETUP_BACKUP.md (this file)
├── db/
│   ├── Dockerfile
│   ├── .env
│   └── init/
│       └── 01-init.sql
├── ollama/
│   ├── Dockerfile
│   ├── .env
│   ├── startup.sh
│   ├── model_loader.sh
│   └── models/
├── tinybert/
│   ├── Dockerfile
│   ├── app.env
│   ├── requirements.txt
│   └── app/
│       └── main.py
├── nginx/
│   ├── nginx.conf
│   └── ssl/
└── docs/
    ├── deployment_instructions.md
    ├── access_services.md
    ├── troubleshoot.md
    └── architecture_diagram.txt
```

## Services and Ports
| Service | Container Name | Port | Volume | Notes |
|---------|---------------|------|--------|-------|
| PostgreSQL | postgres_ai | 65432 | postgres_data | Main database |
| pgAdmin | pgadmin_ai | 5051 | pgadmin_data | Web DB admin |
| DBeaver | dbeaver_ai | 8978 | dbeaver_data | CloudBeaver web interface |
| OpenWebUI | open_webui_ai | 8081 | open-webui-data | AI chat interface |
| Ollama | ollama_ai | 11434 | ollama_data | LLM server |
| TinyBERT | tinybert_ai | 8083 | tinybert_models | Transformer service |
| Nginx | nginx_ssl_proxy | 80,443 | nginx_logs | SSL proxy |
| Tailscale | tailscale_ai | - | tailscale_data | VPN access |

## Key Features
- HTTPS/SSL support via Nginx
- GPU support for Ollama (NVIDIA)
- Tailscale for secure external access
- Persistent volumes for data
- Network isolation (172.20.0.0/16)
- Auto-restart policies

## If Moving Directory
1. Stop containers: `docker-compose down`
2. Move directory to new location
3. Navigate to new location: `cd /new/path/PostgresAI`
4. Rebuild and start: `docker-compose up --build -d`

## Volume Management
Volumes are named and persist independently of directory location:
- postgres_data
- pgadmin_data
- dbeaver_data
- open-webui-data
- ollama_data
- ollama_model_loader_data
- tinybert_models
- tailscale_data
- nginx_logs

## Environment Variables Required
```
# Main .env
POSTGRES_DB=postgres_ai
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
PGADMIN_EMAIL=admin@example.com
PGADMIN_PASSWORD=admin_password
WEBUI_SECRET_KEY=your_secret_key
FLASK_ENV=production
TS_AUTHKEY=your_tailscale_key

# db/.env
POSTGRES_PASSWORD=your_secure_password

# ollama/.env
OLLAMA_HOST=0.0.0.0
MODEL_NAME=deepseek:latest

# tinybert/app.env
MODEL_NAME=distilbert-base-uncased
FLASK_ENV=production
```

## Quick Start Commands
```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Rebuild after changes
docker-compose up --build -d

# Check ports
./check_ports.sh
```

## Access URLs (after setup)
- PostgreSQL: localhost:65432
- pgAdmin: http://localhost:5051
- DBeaver: http://localhost:8978
- OpenWebUI: http://localhost:8081
- Ollama API: http://localhost:11434
- TinyBERT: http://localhost:8083

## GitHub Repository
Repository: https://github.com/jrblh75/PostgresAI

## Notes
- Ensure Docker Desktop is running before starting
- GPU support requires NVIDIA Docker runtime
- SSL certificates need to be generated for nginx/ssl/
- Tailscale requires auth key setup
- All services use custom network: postgres_ai_network (172.20.0.0/16)

## Docker Compose Version
Uses Docker Compose version 3.8

Created: July 4, 2025
