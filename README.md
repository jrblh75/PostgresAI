# PostgresAI Docker Container System

A comprehensive Docker-based AI and database platform combining PostgreSQL, AI services (Ollama, TinyBERT), and web interfaces with SSL/HTTPS support and VPN access.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/jrblh75/PostgresAI.git
cd PostgresAI

# Configure environment variables
cp .env.example .env
# Edit .env with your settings

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## Services & Ports

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 65432 | Primary database |
| pgAdmin | 5051 | Web database admin |
| DBeaver | 8978 | Cloud database interface |
| OpenWebUI | 8081 | AI chat interface |
| Ollama | 11434 | LLM API server |
| TinyBERT | 8083 | Transformer API |
| Nginx | 80,443 | SSL reverse proxy |

## Features

- 🔒 SSL/HTTPS support via Nginx
- 🖥️ GPU support for AI models (NVIDIA)
- 🌐 VPN access through Tailscale
- 📊 Multiple database interfaces
- 🤖 AI chat interface with OpenWebUI
- 🔄 Auto-restart policies
- 🏠 Network isolation

## Documentation

- [Complete Documentation](PostgresAI_COMPLETE_DOCS.md) - Comprehensive guide
- [Setup & Backup Guide](SETUP_BACKUP.md) - Installation and recovery
- [docs/](docs/) - Additional documentation

## Architecture

```
PostgresAI/
├── docker-compose.yml          # Main orchestration
├── .env                       # Environment variables
├── db/                        # PostgreSQL setup
├── ollama/                    # AI model server
├── tinybert/                  # Transformer service
├── nginx/                     # SSL proxy
└── docs/                      # Documentation
```

## Requirements

- Docker Desktop
- Docker Compose v3.8+
- 8GB+ RAM recommended
- NVIDIA Docker runtime (for GPU support)

## License

MIT License - see LICENSE file for details.

---

Created: July 4, 2025
