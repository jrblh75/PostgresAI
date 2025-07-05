# Service Access Guide

## Default Access Points

### Web Services

| Service | HTTP Port | HTTPS Port | Default URL | HTTPS URL |
|---------|-----------|------------|-------------|-----------|
| pgAdmin | 5051 | 443 | `http://localhost:5051` | `https://pgadmin.localhost` |
| OpenWebUI | 8081 | 443 | `http://localhost:8081` | `https://webui.localhost` |
| DBeaver CloudBeaver | 8978 | N/A | `http://localhost:8978` | N/A |
| TinyBERT API | 8083 | 443 | `http://localhost:8083` | `https://tinybert.localhost` |
| Ollama API | 11434 | 443 | `http://localhost:11434` | `https://ollama.localhost` |

### Database Services

| Service | Port | Connection String |
|---------|------|-------------------|
| PostgreSQL | 65432 | `postgresql://postgres_admin:password@localhost:65432/postgres_ai` |

## Service-Specific Access Instructions

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
   - `GET /api/tags` - List models
   - `POST /api/generate` - Generate text
   - `POST /api/chat` - Chat completion
   - `POST /api/pull` - Pull new models

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

## Troubleshooting Access Issues

1. **Service not responding**: Check if containers are running
2. **Connection refused**: Verify port mappings
3. **SSL errors**: Check certificate configuration
4. **Authentication failed**: Verify credentials in `.env`
5. **Network issues**: Check Docker network configuration
