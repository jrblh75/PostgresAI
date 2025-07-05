# PostgresAI Docker Deployment Instructions

## Prerequisites

1. **Docker and Docker Compose** installed
2. **NVIDIA Docker** (for GPU support with Ollama)
3. **Tailscale account** (for external access)
4. **SSL certificates** (see SSL setup section)

## Quick Start

### 1. Clone and Setup
```bash
git clone <repository>
cd PostgresAI
cp .env.example .env
```

### 2. Configure Environment Variables
Edit `.env` file with your specific settings:
- Update PostgreSQL credentials
- Set Tailscale auth key
- Configure SSL certificate paths
- Set secure passwords and keys

### 3. Generate SSL Certificates
```bash
# Create self-signed certificates (for development)
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
```

### 4. Build and Start Services
```bash
# Build all services
docker-compose build

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## Service Access

| Service | Port | HTTPS URL | Local URL |
|---------|------|-----------|-----------|
| PostgreSQL | 65432 | N/A | localhost:65432 |
| pgAdmin | 5051 | https://pgadmin.localhost | http://localhost:5051 |
| DBeaver | 8978 | N/A | http://localhost:8978 |
| OpenWebUI | 8081 | https://webui.localhost | http://localhost:8081 |
| Ollama API | 11434 | https://ollama.localhost | http://localhost:11434 |
| TinyBERT | 8083 | https://tinybert.localhost | http://localhost:8083 |

## GPU Setup (NVIDIA)

1. Install NVIDIA Container Toolkit:
```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

2. Verify GPU access:
```bash
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## Tailscale Setup

1. Get auth key from Tailscale admin console
2. Update `TS_AUTHKEY` in `.env` file
3. Start services with Tailscale enabled

## Database Connection

### From External Applications:
- **Host**: localhost (or Tailscale IP)
- **Port**: 65432
- **Database**: postgres_ai
- **Username**: postgres_admin
- **Password**: (from .env file)

### Connection String:
```
postgresql://postgres_admin:password@localhost:65432/postgres_ai
```

## Initial Model Loading

Models are automatically loaded when Ollama starts:
- `deepseek:latest`
- `llama2:13b-chat-q4_0`

To load additional models:
```bash
docker exec -it ollama_ai ollama pull <model-name>
```

## Monitoring and Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f postgres
docker-compose logs -f ollama
docker-compose logs -f tinybert

# Check service health
docker-compose ps
```

## Data Persistence

All data is persisted in Docker volumes:
- `postgres_data`: PostgreSQL database files
- `ollama_data`: Ollama models and data
- `open-webui-data`: OpenWebUI data
- `tinybert_models`: TinyBERT model cache

## Backup and Restore

### PostgreSQL Backup:
```bash
docker exec postgres_ai pg_dump -U postgres_admin postgres_ai > backup.sql
```

### PostgreSQL Restore:
```bash
docker exec -i postgres_ai psql -U postgres_admin postgres_ai < backup.sql
```

## Troubleshooting

See `troubleshoot.md` for common issues and solutions.

## Security Notes

1. Change all default passwords in `.env`
2. Use proper SSL certificates for production
3. Configure firewall rules appropriately
4. Regularly update Docker images
5. Monitor access logs
