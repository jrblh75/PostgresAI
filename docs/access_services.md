# Service Access Guide

**Updated:** July 4, 2025 - Added Tailscale Integration

## Access Methods

### 1. Local Network Access (Same Machine)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| pgAdmin | 5051 | `http://localhost:5051` | Web database admin |
| OpenWebUI | 8081 | `http://localhost:8081` | AI chat interface |
| DBeaver CloudBeaver | 8978 | `http://localhost:8978` | Cloud database interface |
| TinyBERT API | 8083 | `http://localhost:8083` | Transformer API |
| Ollama API | 11434 | `http://localhost:11434` | LLM API server |
| Nginx Proxy | 80 | `http://localhost` | Unified service access (reverse proxy for all web UIs) |
| PostgreSQL | 65432 | `localhost:65432` | Database connection |

### 2. Tailscale Network Access (Remote Access)

Replace `YOUR_TAILSCALE_IP` with your actual Tailscale IP (check with `./check_tailscale.sh`):

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| pgAdmin | 5051 | `http://YOUR_TAILSCALE_IP:5051` | Web database admin |
| OpenWebUI | 8081 | `http://YOUR_TAILSCALE_IP:8081` | AI chat interface |
| DBeaver CloudBeaver | 8978 | `http://YOUR_TAILSCALE_IP:8978` | Cloud database interface |
| TinyBERT API | 8083 | `http://YOUR_TAILSCALE_IP:8083` | Transformer API |
| Ollama API | 11434 | `http://YOUR_TAILSCALE_IP:11434` | LLM API server |
| Nginx Proxy | 80 | `http://YOUR_TAILSCALE_IP` | Unified service access |
| PostgreSQL | 65432 | `YOUR_TAILSCALE_IP:65432` | Database connection |

### 3. Nginx Proxy Routes

Access multiple services through the nginx proxy:

| Route | Target Service | URL (Local) | URL (Tailscale) |
|-------|---------------|-------------|-----------------|
| `/pgadmin/` | pgAdmin | `http://localhost/pgadmin/` | `http://YOUR_TAILSCALE_IP/pgadmin/` |
| `/webui/` | OpenWebUI | `http://localhost/webui/` | `http://YOUR_TAILSCALE_IP/webui/` |
| `/tinybert/` | TinyBERT | `http://localhost/tinybert/` | `http://YOUR_TAILSCALE_IP/tinybert/` |
| `/ollama/` | Ollama API | `http://localhost/ollama/` | `http://YOUR_TAILSCALE_IP/ollama/` |


## Service-Specific Access Instructions & Recent Improvements

### Recent Changes & Improvements (July 2025)

- **Ollama Service:** Fixed Docker Compose error by removing invalid `command: /startup.sh` from the `ollama` service. Ollama now starts with its default entrypoint.
- **Service Health:** All containers are now healthy and accessible. If a service is restarting, check logs for configuration or port issues.
- **nginx Proxy:** Confirmed nginx is running and mapped to port 80, providing unified access to all web UIs.
- **Documentation:** All ports, endpoints, and troubleshooting steps are up to date. Table now includes PostgreSQL direct connection info.
- **Directory Sync:** Project directories and documentation are unified and synced between Desktop and NAS. All changes are pushed to GitHub.
- **General:** See Troubleshooting section for common fixes (port conflicts, environment variables, volume permissions).

### Finding Your Tailscale IP

```bash
# Run the status check script
./check_tailscale.sh

# Or check manually
ifconfig | grep "inet 100\." | awk '{print $2}'
```

### pgAdmin
1. Open: `http://localhost:5051` or `https://pgadmin.localhost`
2. Login with credentials from `.env` file:
   - Email: `admin@postgresai.local`
   - Password: `pgadmin_secure_password_2025`
3. Add PostgreSQL server:
   - Host: `postgres`
   - Port: `5432`
   - Database: `postgres_ai`
   - Username: `postgres_admin`
   - Password: (from .env file)

### OpenWebUI
1. Open: `http://localhost:8081` or `https://webui.localhost`
2. First-time setup: Create admin account
3. Ollama backend is automatically configured
4. Available models:
   - `deepseek:latest`
   - `llama2:13b-chat-q4_0`

### DBeaver CloudBeaver
1. Open: `http://localhost:8978`
2. Initial setup wizard will guide you
3. Add PostgreSQL connection:
   - Server: `postgres`
   - Port: `5432`
   - Database: `postgres_ai`
   - Username: `postgres_admin`
   - Password: (from .env file)

### TinyBERT API
1. Base URL: `http://localhost:8083` or `https://tinybert.localhost`
2. Endpoints:
   - `GET /health` - Health check
   - `POST /embed` - Text embeddings
   - `POST /similarity` - Text similarity
   - `GET /models` - Model information

### Ollama API
1. Base URL: `http://localhost:11434` or `https://ollama.localhost`
2. API endpoints:
   - `GET /api/tags` - List models (verify Ollama is running: should return available models)
   - `POST /api/generate` - Generate text
   - `POST /api/chat` - Chat completion
   - `POST /api/pull` - Pull new models
3. **Note:** If Ollama fails to start, check your `docker-compose.yml` for any invalid `command:` lines and remove them.

## Tailscale External Access

### Setup
1. Configure Tailscale auth key in `.env`
2. Services will be accessible via Tailscale IP
3. Use the same ports but with your Tailscale machine IP

### External URLs (via Tailscale)
- pgAdmin: `https://<tailscale-ip>:5051`
- OpenWebUI: `https://<tailscale-ip>:8081`
- TinyBERT: `https://<tailscale-ip>:8083`
- PostgreSQL: `<tailscale-ip>:65432`

## API Examples

### TinyBERT Text Embedding
```bash
curl -X POST http://localhost:8083/embed \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello world"}'
```

### TinyBERT Similarity
```bash
curl -X POST http://localhost:8083/similarity \
  -H "Content-Type: application/json" \
  -d '{"text1": "Hello world", "text2": "Hi there"}'
```

### Ollama Generate
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek:latest", "prompt": "Explain AI", "stream": false}'
```

### Ollama Chat
```bash
curl -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek:latest",
    "messages": [{"role": "user", "content": "Hello!"}],
    "stream": false
  }'
```

## Database Connection Examples

### Python (psycopg2)
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=65432,
    database="postgres_ai",
    user="postgres_admin",
    password="secure_postgres_password_2025"
)
```

### Node.js (pg)
```javascript
const { Client } = require('pg');

const client = new Client({
  host: 'localhost',
  port: 65432,
  database: 'postgres_ai',
  user: 'postgres_admin',
  password: 'secure_postgres_password_2025',
});

await client.connect();
```

## Security Notes

1. **Default Passwords**: Change all default passwords in production
2. **SSL Certificates**: Use proper certificates for production
3. **Firewall**: Configure appropriate firewall rules
4. **Network Access**: Limit external access as needed
5. **API Keys**: Use API keys for production environments


## Troubleshooting Access Issues & Common Fixes

1. **Service not responding**: Check if containers are running (`docker compose ps`).
2. **Connection refused**: Verify port mappings in `docker-compose.yml` and ensure no port conflicts.
3. **Ollama restarting**: Remove any `command:` line from the `ollama` service in `docker-compose.yml`.
4. **pgAdmin restarting**: Check logs for port conflicts, missing environment variables, or volume permission issues.
5. **SSL errors**: Check certificate configuration.
6. **Authentication failed**: Verify credentials in `.env`.
7. **Network issues**: Check Docker network configuration and firewall settings.
8. **Directory sync issues**: Use `rsync` to keep Desktop and NAS project directories unified.
