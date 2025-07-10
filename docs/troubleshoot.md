# PostgresAI Troubleshooting Guide

This document provides solutions for common issues you might encounter with PostgresAI.

## Database Connectivity Issues

### Cannot connect to the PostgreSQL database

**Symptoms:**
- Error messages like "could not connect to server"
- Connection timeouts

**Solutions:**
1. Verify the PostgreSQL container is running:
   ```bash
   docker ps | grep postgresai_db
   ```

2. Check PostgreSQL logs:
   ```bash
   docker-compose logs postgres
   ```

3. Verify PostgreSQL credentials in your `.env` file

4. Try connecting with psql:
   ```bash
   docker exec -it postgresai_db psql -U postgres_admin -d postgres_ai
   ```

## Ollama Model Issues

### Models fail to load

**Symptoms:**
- Missing models in API responses
- Errors in Ollama logs

**Solutions:**
1. Check Ollama container logs:
   ```bash
   docker-compose logs ollama
   ```

2. Restart the Ollama container:
   ```bash
   docker-compose restart ollama
   ```

3. Manually load a model:
   ```bash
   docker exec -it postgresai_ollama ollama pull llama3
   ```

## SSL/TLS Certificate Issues

**Symptoms:**
- Browser warnings about insecure connections
- Certificate errors

**Solutions:**
1. For development, accept the self-signed certificate in your browser

2. For production, replace the certificates:
   - Place your SSL certificate and key in `nginx/ssl/`
   - Update the nginx configuration accordingly
   - Restart the Nginx container:
     ```bash
     docker-compose restart nginx
     ```

## Performance Issues

**Symptoms:**
- Slow query responses
- High CPU/memory usage

**Solutions:**
1. Check resource usage:
   ```bash
   docker stats
   ```

2. Optimize PostgreSQL configuration:
   - Edit `db/postgresql.conf`
   - Increase `shared_buffers` for more memory
   - Adjust `max_connections` based on your needs

3. Restart the stack with updated configuration:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Container Startup Failures

**Symptoms:**
- Containers exit immediately after starting
- Health checks fail

**Solutions:**
1. Check container logs:
   ```bash
   docker-compose logs
   ```

2. Verify Docker configuration:
   ```bash
   docker info
   ```

3. Check for port conflicts:
   ```bash
   netstat -tuln | grep '5432\|8443\|11434'
   ```

4. Try restarting Docker:
   ```bash
   sudo systemctl restart docker
   ```

## Need Additional Help?

If you're still experiencing issues, please:

1. Gather information with the diagnostic tool:
   ```bash
   ./collect_diagnostics.sh
   ```

2. Open an issue on GitHub with the diagnostic output
