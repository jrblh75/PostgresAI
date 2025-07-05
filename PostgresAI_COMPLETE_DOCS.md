# PostgresAI Docker Container System - Complete Documentation

**Created:** July 4, 2025  
**Updated:** July 4, 2025 - Tailscale Integration & NAS Deployment  
**Version:** 2.0  
**Repository:** https://github.com/jrblh75/PostgresAI  
**Deployment Location:** `/Volumes/NASté-DockerHD/|Projects (Holding)/GitHub/Active Repos/PostgresAI`

## Table of Contents
1. [Overview](#overview)
2. [Tailscale Integration](#tailscale-integration)
3. [Architecture](#architecture)
4. [Services Configuration](#services-configuration)
5. [Network & Security](#network--security)
6. [Installation & Setup](#installation--setup)
7. [Service Access](#service-access)
8. [Environment Configuration](#environment-configuration)
9. [Volume Management](#volume-management)
10. [Management Scripts](#management-scripts)
11. [Troubleshooting](#troubleshooting)
12. [Backup & Recovery](#backup--recovery)

---

## Overview

PostgresAI is a comprehensive Docker-based AI and database platform that combines:
- **Database Services**: PostgreSQL with pgAdmin and DBeaver interfaces
- **AI Services**: Ollama LLM server with OpenWebUI interface
- **ML Services**: TinyBERT transformer service
- **Infrastructure**: Nginx reverse proxy with Tailscale VPN integration
- **Remote Access**: Secure connectivity via Tailscale from any device

### Key Features
- � **Tailscale VPN Integration** - Secure remote access from any device on your Tailnet
- �️ **PostgreSQL Database** - Primary database with custom extensions and initialization
- 🤖 **AI Services** - Ollama LLMs with OpenWebUI chat interface
- 🧠 **ML Transformers** - TinyBERT service for text processing
- 📊 **Multiple DB Interfaces** - pgAdmin web UI and DBeaver cloud interface
- 🔄 **Auto-restart Policies** - Production-ready with health checks
- 🏠 **Network Isolation** - Secure Docker bridge network (172.20.0.0/16)
- 📡 **HTTP Proxy** - Nginx for unified service access
- 💾 **NAS Deployment** - Optimized for network storage with persistence

---

## Tailscale Integration

### Overview
This deployment integrates with Tailscale to provide secure remote access to all services from any device on your Tailnet.

### Architecture
- **Tailscale Desktop**: Running on host system
- **Container Integration**: Tailscale container with host networking
- **Route Advertisement**: Docker subnet (172.20.0.0/16) advertised to Tailnet
- **Access Method**: All services accessible via your Tailscale IP

### Configuration
```yaml
tailscale:
  image: tailscale/tailscale:latest
  network_mode: host
  environment:
    - TS_AUTHKEY=${TS_AUTHKEY}
    - TS_EXTRA_ARGS=--advertise-routes=172.20.0.0/16 --accept-routes
  cap_add:
    - NET_ADMIN
    - NET_RAW
  privileged: true
```

### Benefits
- **Universal Access**: Access from phones, tablets, laptops anywhere
- **No Port Forwarding**: No need to expose services to public internet
- **Secure by Default**: All traffic encrypted and authenticated
- **Zero Configuration**: Works with existing Tailscale setup

---

## Architecture

### Directory Structure
```
PostgresAI/
├── docker-compose.yml              # Main orchestration file
├── .env                           # Main environment variables
├── check_ports.sh                 # Port monitoring script
├── create_docs_archive.sh         # Documentation archiver
├── SETUP_BACKUP.md               # Backup/recovery guide
├── PostgresAI_COMPLETE_DOCS.md   # This comprehensive guide
│
├── db/                            # PostgreSQL Database
│   ├── Dockerfile                 # Custom PostgreSQL image
│   ├── .env                      # Database environment
│   └── init/                     # Database initialization
│       └── 01-init.sql           # Initial schema/data
│
├── ollama/                        # AI Language Model Server
│   ├── Dockerfile                # Ollama custom image
│   ├── .env                      # Ollama environment
│   ├── startup.sh                # Container startup script
│   ├── model_loader.sh           # Model loading script
│   └── models/                   # Model storage directory
│
├── tinybert/                      # Transformer Service
│   ├── Dockerfile                # TinyBERT custom image
│   ├── app.env                   # Application environment
│   ├── requirements.txt          # Python dependencies
│   └── app/                      # Application code
│       └── main.py               # Flask application
│
├── nginx/                         # Reverse Proxy & SSL
│   ├── nginx.conf                # Nginx configuration
│   └── ssl/                      # SSL certificates directory
│
└── docs/                          # Documentation
    ├── deployment_instructions.md  # Deployment guide
    ├── access_services.md         # Service access guide
    ├── troubleshoot.md            # Troubleshooting guide
    └── architecture_diagram.txt   # System architecture
```

### Network Architecture
```
Docker Network: postgres_ai_network (172.20.0.0/16)
│
├── postgres_ai (172.20.0.2)      - PostgreSQL Database
├── pgadmin_ai (172.20.0.3)       - Database Admin Interface
├── dbeaver_ai (172.20.0.4)       - CloudBeaver Web Interface
├── ollama_ai (172.20.0.5)        - AI Language Model Server
├── open_webui_ai (172.20.0.6)    - AI Chat Interface
├── tinybert_ai (172.20.0.7)      - Transformer Service
├── tailscale_ai (172.20.0.8)     - VPN Access Service
└── nginx_ssl_proxy (172.20.0.9)  - SSL Reverse Proxy
```

---

## Services Configuration

### Service Overview
| Service | Container Name | External Port | Internal Port | Purpose |
|---------|---------------|---------------|---------------|---------|
| PostgreSQL | postgres_ai | 65432 | 5432 | Primary database |
| pgAdmin | pgadmin_ai | 5051 | 80 | Web database admin |
| DBeaver | dbeaver_ai | 8978 | 8978 | Cloud database interface |
| Ollama | ollama_ai | 11434 | 11434 | LLM API server |
| OpenWebUI | open_webui_ai | 8081 | 8080 | AI chat interface |
| TinyBERT | tinybert_ai | 8083 | 8083 | Transformer API |
| Nginx | nginx_ssl_proxy | 80,443 | 80,443 | SSL reverse proxy |
| Tailscale | tailscale_ai | - | - | VPN networking |

### Service Dependencies
```
nginx ← depends on
├── postgres
├── pgadmin
├── open-webui
└── tinybert

pgadmin ← depends on
└── postgres

dbeaver ← depends on
└── postgres

open-webui ← depends on
└── ollama
```

---

## Network & Security

### Network Configuration
- **Network Name**: `postgres_ai_network`
- **Driver**: Bridge
- **Subnet**: `172.20.0.0/16`
- **Isolation**: All services isolated from host network

### Security Features
1. **SSL/TLS Termination**
   - Nginx handles SSL certificates
   - HTTPS redirect capability
   - Certificate storage in `nginx/ssl/`

2. **VPN Access**
   - Tailscale integration for secure external access
   - Route advertisement: `172.20.0.0/16`
   - Requires Tailscale auth key

3. **Container Security**
   - Non-root users where applicable
   - Limited capabilities and privileges
   - Network isolation between services

4. **Access Control**
   - Environment-based authentication
   - OAuth support in OpenWebUI
   - Database user management

---

## Installation & Setup

### Prerequisites
- Docker Desktop installed and running
- Docker Compose v3.8+
- NVIDIA Docker runtime (for GPU support)
- 8GB+ RAM recommended

### Quick Start
```bash
# 1. Clone or extract the PostgresAI directory
cd PostgresAI

# 2. Configure environment variables
cp .env.example .env  # Edit with your settings

# 3. Start all services
docker-compose up -d

# 4. Check service status
docker-compose ps

# 5. View logs
docker-compose logs -f
```

### Initial Configuration
1. **Environment Setup**: Configure all `.env` files
2. **SSL Certificates**: Generate or place certificates in `nginx/ssl/`
3. **Database Initialization**: Scripts in `db/init/` run automatically
4. **Model Loading**: Ollama models download on first start
5. **Tailscale Setup**: Configure with your auth key

---

## Service Access

### Direct Access URLs
- **PostgreSQL**: `localhost:65432`
  - Connection: `postgresql://postgres:password@localhost:65432/postgres_ai`
- **pgAdmin**: `http://localhost:5051`
  - Login with PGADMIN_EMAIL/PGADMIN_PASSWORD
- **DBeaver**: `http://localhost:8978`
  - Web-based database interface
- **OpenWebUI**: `http://localhost:8081`
  - AI chat interface
- **Ollama API**: `http://localhost:11434`
  - Direct API access for models
- **TinyBERT**: `http://localhost:8083`
  - Transformer API endpoints

### API Endpoints
```bash
# Ollama API
curl http://localhost:11434/api/tags          # List models
curl http://localhost:11434/api/generate      # Generate text

# TinyBERT API
curl http://localhost:8083/predict           # Text prediction
curl http://localhost:8083/health            # Health check
```

---

## Environment Configuration

### Main Environment (.env)
```bash
# Database Configuration
POSTGRES_DB=postgres_ai
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password

# pgAdmin Configuration
PGADMIN_EMAIL=admin@example.com
PGADMIN_PASSWORD=admin_password

# OpenWebUI Configuration
WEBUI_SECRET_KEY=your_secret_key

# Application Environment
FLASK_ENV=production

# Tailscale Configuration
TS_AUTHKEY=your_tailscale_auth_key
```

### Database Environment (db/.env)
```bash
POSTGRES_PASSWORD=your_secure_password
```

### Ollama Environment (ollama/.env)
```bash
OLLAMA_HOST=0.0.0.0
MODEL_NAME=deepseek:latest
```

### TinyBERT Environment (tinybert/app.env)
```bash
MODEL_NAME=distilbert-base-uncased
FLASK_ENV=production
```

---

## Volume Management

### Named Volumes (Persistent Data)
```
postgres_data          → PostgreSQL database files
pgadmin_data           → pgAdmin configuration and sessions
dbeaver_data           → DBeaver workspace and connections
open-webui-data        → OpenWebUI data and conversations
ollama_data            → Ollama models and configuration
ollama_model_loader_data → Model storage and cache
tinybert_models        → TinyBERT model files
tailscale_data         → Tailscale configuration and state
nginx_logs             → Nginx access and error logs
```

### Bind Mounts (Configuration Files)
```
./db/init              → Database initialization scripts
./nginx/nginx.conf     → Nginx configuration
./nginx/ssl            → SSL certificates
/dev/net/tun           → Tailscale network interface
```

### Volume Commands
```bash
# List all volumes
docker volume ls | grep postgres

# Inspect volume
docker volume inspect postgres_data

# Backup volume
docker run --rm -v postgres_data:/data -v $(pwd):/backup ubuntu tar czf /backup/postgres_backup.tar.gz /data

# Restore volume
docker run --rm -v postgres_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/postgres_backup.tar.gz -C /
```

---

## Troubleshooting

### Common Issues

#### 1. Port Conflicts
```bash
# Check port usage
./check_ports.sh

# Find process using port
lsof -i :65432

# Kill process
sudo kill -9 <PID>
```

#### 2. Service Won't Start
```bash
# Check service logs
docker-compose logs [service_name]

# Rebuild service
docker-compose up --build [service_name]

# Reset service
docker-compose stop [service_name]
docker-compose rm [service_name]
docker-compose up -d [service_name]
```

#### 3. Database Connection Issues
```bash
# Test PostgreSQL connection
docker exec -it postgres_ai psql -U postgres -d postgres_ai

# Check database logs
docker-compose logs postgres

# Verify environment variables
docker exec postgres_ai env | grep POSTGRES
```

#### 4. GPU Not Detected
```bash
# Check NVIDIA Docker runtime
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# Verify GPU in container
docker exec ollama_ai nvidia-smi
```

### Log Monitoring
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f postgres

# Last 100 lines
docker-compose logs --tail=100

# Real-time with timestamps
docker-compose logs -f -t
```

---

## Backup & Recovery

### Complete System Backup
```bash
# Create documentation archive
./create_docs_archive.sh

# Export all configurations
docker-compose config > docker-compose-resolved.yml

# Backup all volumes
for volume in $(docker volume ls -q | grep postgres); do
    docker run --rm -v $volume:/data -v $(pwd)/backups:/backup ubuntu tar czf /backup/$volume-$(date +%Y%m%d).tar.gz /data
done
```

### Database Backup
```bash
# PostgreSQL dump
docker exec postgres_ai pg_dump -U postgres postgres_ai > postgres_backup.sql

# Restore from dump
docker exec -i postgres_ai psql -U postgres postgres_ai < postgres_backup.sql
```

### Service-Specific Backups
```bash
# Ollama models
docker exec ollama_ai ollama list > ollama_models.txt

# OpenWebUI data
docker cp open_webui_ai:/app/backend/data ./openwebui_backup/

# pgAdmin configuration
docker cp pgadmin_ai:/var/lib/pgadmin ./pgadmin_backup/
```

### Recovery Procedures

#### 1. Directory Moved/Relocated
```bash
# Stop all services
docker-compose down

# Move to new location
mv /old/path/PostgresAI /new/path/PostgresAI

# Navigate to new location
cd /new/path/PostgresAI

# Restart services (volumes auto-reconnect)
docker-compose up -d
```

#### 2. Complete System Recovery
```bash
# Extract backup archive
tar -xzf PostgresAI_Complete_Documentation_*.tar.gz

# Navigate to directory
cd PostgresAI_Complete_Docs

# Configure environment
vim .env  # Update with your settings

# Start services
docker-compose up -d

# Verify all services
docker-compose ps
```

#### 3. Single Service Recovery
```bash
# Stop service
docker-compose stop [service_name]

# Remove container
docker-compose rm [service_name]

# Rebuild and start
docker-compose up --build -d [service_name]
```

---

## Performance Optimization

### Resource Allocation
```yaml
# Add to docker-compose.yml for specific services
deploy:
  resources:
    limits:
      memory: 2G
      cpus: '1.0'
    reservations:
      memory: 1G
      cpus: '0.5'
```

### Database Tuning
```sql
-- PostgreSQL optimization queries
SHOW shared_buffers;
SHOW effective_cache_size;
SHOW work_mem;

-- Update configuration
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
SELECT pg_reload_conf();
```

### Monitoring Commands
```bash
# Resource usage
docker stats

# Service health
docker-compose ps

# Network usage
docker network inspect postgres_ai_network

# Disk usage
docker system df
```

---

## Maintenance

### Regular Tasks
```bash
# Update images
docker-compose pull
docker-compose up -d

# Clean unused resources
docker system prune -a

# Rotate logs
docker-compose logs --since 7d > logs_archive.txt

# Check disk usage
docker system df
```

### Security Updates
```bash
# Update base images
docker-compose build --no-cache --pull

# Restart with new images
docker-compose up -d

# Verify versions
docker-compose exec postgres psql --version
docker-compose exec ollama_ai ollama --version
```

---

## Support & Resources

### Documentation Files
- `SETUP_BACKUP.md` - Complete backup and recovery guide
- `docs/deployment_instructions.md` - Detailed deployment steps
- `docs/access_services.md` - Service access information
- `docs/troubleshoot.md` - Common problem solutions
- `docs/architecture_diagram.txt` - System architecture overview

### Useful Commands Reference
```bash
# Quick status check
docker-compose ps && docker stats --no-stream

# Full system restart
docker-compose down && docker-compose up -d

# View all logs since start
docker-compose logs --since $(docker-compose ps -q | head -1 | xargs docker inspect -f '{{.State.StartedAt}}')

# Emergency stop
docker-compose kill && docker-compose down

# Complete reset (DANGER: deletes all data)
docker-compose down -v && docker system prune -a
```

### Repository Information
- **GitHub**: https://github.com/jrblh75/PostgresAI
- **Issues**: Report problems via GitHub issues
- **Updates**: Check repository for latest versions

---

**End of Documentation**  
*Last Updated: July 4, 2025*
