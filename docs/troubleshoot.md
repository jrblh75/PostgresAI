# Troubleshooting Guide

## Common Issues and Solutions

### Container Issues

#### Containers won't start
```bash
# Check container status
docker-compose ps

# View container logs
docker-compose logs <service-name>

# Restart specific service
docker-compose restart <service-name>

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

#### Out of memory errors
```bash
# Check system resources
docker system df
docker stats

# Clean up unused resources
docker system prune -a
docker volume prune
```

### Database Issues

#### PostgreSQL connection failed
1. Check if PostgreSQL container is running
2. Verify port 65432 is not in use
3. Check credentials in `.env` file
4. Test connection:
```bash
docker exec -it postgres_ai psql -U postgres_admin -d postgres_ai
```

#### pgAdmin login issues
1. Verify credentials in `.env` file
2. Reset pgAdmin password:
```bash
docker exec -it pgadmin_ai python3 /pgadmin4/setup.py
```

### AI Service Issues

#### Ollama models not loading
```bash
# Check Ollama status
docker exec -it ollama_ai ollama list

# Manually pull models
docker exec -it ollama_ai ollama pull deepseek:latest
docker exec -it ollama_ai ollama pull llama2:13b-chat-q4_0

# Check GPU access
docker exec -it ollama_ai nvidia-smi
```

#### TinyBERT API errors
```bash
# Check service health
curl http://localhost:8083/health

# View logs
docker-compose logs tinybert

# Restart service
docker-compose restart tinybert
```

#### OpenWebUI connection issues
1. Check if Ollama is running and accessible
2. Verify network connectivity:
```bash
docker exec -it open_webui_ai curl http://ollama:11434/api/tags
```

### Network Issues

#### Port conflicts
```bash
# Check what's using ports
lsof -i :65432
lsof -i :5051
lsof -i :8081
lsof -i :11434
lsof -i :8083

# Kill processes using ports
sudo kill -9 <PID>
```

#### SSL/HTTPS issues
1. Verify SSL certificates exist:
```bash
ls -la nginx/ssl/
```

2. Generate new certificates:
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem
```

3. Check Nginx configuration:
```bash
docker exec -it nginx_ssl_proxy nginx -t
```

### Tailscale Issues

#### Tailscale not connecting
1. Verify auth key in `.env` file
2. Check Tailscale status:
```bash
docker exec -it tailscale_ai tailscale status
```

3. Re-authenticate:
```bash
docker exec -it tailscale_ai tailscale up --authkey=<new-key>
```

### Performance Issues

#### High CPU/Memory usage
```bash
# Monitor resource usage
docker stats

# Check individual service usage
docker exec -it <container> top
```

#### Slow model inference
1. Verify GPU access for Ollama
2. Check model size and available VRAM
3. Consider using smaller models for testing

### Data Issues

#### Volume mount problems
```bash
# Check volume status
docker volume ls
docker volume inspect <volume-name>

# Fix permissions
sudo chown -R $USER:$USER ./data
```

#### Data not persisting
1. Verify volume mounts in docker-compose.yml
2. Check if volumes are properly created
3. Ensure containers have write permissions

### Log Analysis

#### View all logs
```bash
docker-compose logs -f --tail=100
```

#### Service-specific logs
```bash
docker-compose logs -f postgres
docker-compose logs -f ollama
docker-compose logs -f tinybert
docker-compose logs -f open-webui
docker-compose logs -f tailscale
```

#### Log rotation
```bash
# Clear all logs
docker-compose down
docker system prune -a
docker-compose up -d
```

## Emergency Recovery

### Complete reset
```bash
# Stop all services
docker-compose down -v

# Remove all containers and volumes
docker system prune -a
docker volume prune

# Rebuild from scratch
docker-compose build --no-cache
docker-compose up -d
```

### Backup before reset
```bash
# Backup PostgreSQL data
docker exec postgres_ai pg_dump -U postgres_admin postgres_ai > backup_$(date +%Y%m%d).sql

# Backup important volumes
docker run --rm -v postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz /data
```

## Getting Help

### Check system requirements
- Docker version 20.10+
- Docker Compose version 2.0+
- 8GB+ RAM recommended
- 50GB+ free disk space
- NVIDIA GPU (optional, for Ollama)

### Useful commands
```bash
# System information
docker version
docker-compose version
nvidia-smi (if GPU enabled)

# Container inspection
docker inspect <container-name>
docker exec -it <container-name> /bin/bash

# Network debugging
docker network ls
docker network inspect postgres_ai_postgres_ai_network
```

### Support resources
1. Check Docker documentation
2. Review service-specific documentation
3. Search GitHub issues for related projects
4. Check system logs: `journalctl -u docker`
