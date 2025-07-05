# PostgresAI Docker Container System

A comprehensive Docker-based AI and database platform combining PostgreSQL, AI services (Ollama, TinyBERT), and web interfaces with **Tailscale VPN integration** for secure remote access.

## 🌟 Key Features

- 🔐 **Tailscale Integration** - Secure remote access from any device
- 🗄️ **PostgreSQL** - Primary database with custom extensions
- 🤖 **AI Services** - Ollama LLMs + TinyBERT transformers
- 🖥️ **Multiple Interfaces** - pgAdmin, DBeaver, OpenWebUI
- 🔄 **Auto-restart** - Production-ready with health checks
- 📡 **Network Isolation** - Secure Docker networking
- 🏠 **NAS Deployment** - Optimized for network storage

## 🚀 Quick Start

### Option 1: Automatic Setup with Tailscale

```bash
# Clone and navigate
git clone https://github.com/jrblh75/PostgresAI.git
cd PostgresAI

# Quick start with Tailscale integration
./start_with_tailscale.sh
```

### Option 2: Manual Setup

```bash
# Configure environment
cp .env.example .env
# Edit .env with your Tailscale auth key (optional)

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## 🌐 Service Access

### Via Tailscale Network (Remote Access)

Replace `YOUR_TAILSCALE_IP` with your actual Tailscale IP:

| Service | URL | Purpose |
|---------|-----|---------|
| PostgreSQL | `YOUR_TAILSCALE_IP:65432` | Database connection |
| pgAdmin | `http://YOUR_TAILSCALE_IP:5051` | Web database admin |
| DBeaver | `http://YOUR_TAILSCALE_IP:8978` | Cloud database interface |
| OpenWebUI | `http://YOUR_TAILSCALE_IP:8081` | AI chat interface |
| Ollama API | `http://YOUR_TAILSCALE_IP:11434` | LLM API server |
| TinyBERT | `http://YOUR_TAILSCALE_IP:8083` | Transformer API |
| Nginx Proxy | `http://YOUR_TAILSCALE_IP` | Unified service access |

### Via Local Network

| Service | URL | Purpose |
|---------|-----|---------|
| PostgreSQL | `localhost:65432` | Database connection |
| pgAdmin | `http://localhost:5051` | Web database admin |
| DBeaver | `http://localhost:8978` | Cloud database interface |
| OpenWebUI | `http://localhost:8081` | AI chat interface |
| Ollama API | `http://localhost:11434` | LLM API server |
| TinyBERT | `http://localhost:8083` | Transformer API |
| Nginx Proxy | `http://localhost` | Unified service access |

## 🛠️ Management Scripts

```bash
# Check Tailscale and service status
./check_tailscale.sh

# Start with Tailscale integration
./start_with_tailscale.sh

# Check port availability
./check_ports.sh
```

## 📋 Documentation

- [Complete Documentation](PostgresAI_COMPLETE_DOCS.md) - Comprehensive guide with all details
- [Setup & Backup Guide](SETUP_BACKUP.md) - Installation and recovery procedures
- [Tailscale Integration Guide](MOVE_DIRECTORY_INSTRUCTIONS.md) - Network setup
- [docs/](docs/) - Additional technical documentation
  - [Access Services](docs/access_services.md) - Service connectivity guide
  - [Deployment Instructions](docs/deployment_instructions.md) - Production deployment
  - [Troubleshooting](docs/troubleshoot.md) - Common issues and solutions
  - [Architecture Diagram](docs/architecture_diagram.txt) - System overview

## 🏗️ Architecture

```text
PostgresAI Stack with Tailscale Integration
===========================================

┌─────────────────────────────────────────────────────────┐
│                    Tailscale VPN                       │
│  🌐 Remote Access from Any Device on Your Tailnet     │
└─────────────────────────────────────────────────────────┘
                            │
┌─────────────────────────────────────────────────────────┐
│              NAS Storage Location                      │
│  📁 /Volumes/NASté-DockerHD/|Projects/PostgresAI      │
└─────────────────────────────────────────────────────────┘
                            │
┌─────────────────────────────────────────────────────────┐
│               Docker Network (172.20.0.0/16)          │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ PostgreSQL  │  │   pgAdmin   │  │   DBeaver   │     │
│  │   :65432    │  │    :5051    │  │    :8978    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Ollama    │  │ OpenWebUI   │  │  TinyBERT   │     │
│  │   :11434    │  │    :8081    │  │    :8083    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐                      │
│  │ Tailscale   │  │    Nginx    │                      │
│  │(host network)│  │    :80     │                      │
│  └─────────────┘  └─────────────┘                      │
└─────────────────────────────────────────────────────────┘
```

### Directory Structure

```text
PostgresAI/
├── docker-compose.yml          # Main orchestration with Tailscale
├── .env                       # Environment configuration
├── start_with_tailscale.sh    # Quick start script
├── check_tailscale.sh         # Network status checker
├── check_ports.sh             # Port availability checker
├── db/                        # PostgreSQL setup
│   ├── Dockerfile            
│   └── init/01-init.sql      
├── ollama/                    # AI model server
│   ├── Dockerfile
│   ├── startup.sh
│   └── model_loader.sh       
├── tinybert/                  # Transformer service
│   ├── Dockerfile
│   └── app/main.py          
├── nginx/                     # HTTP proxy (SSL ready)
│   └── nginx.conf           
└── docs/                      # Documentation
    ├── access_services.md
    ├── deployment_instructions.md
    ├── troubleshoot.md
    └── architecture_diagram.txt
```

## 🔧 Requirements

- **Docker Desktop** 4.0+ with Docker Compose
- **8GB+ RAM** recommended for all services
- **Tailscale Desktop** (for remote access)
- **NAS or Network Storage** (current deployment)
- NVIDIA Docker runtime (optional, for GPU support)

## 🚀 Production Deployment

This stack is deployed on network storage and optimized for:

- ✅ **High Availability** - Auto-restart policies
- ✅ **Remote Access** - Tailscale VPN integration  
- ✅ **Data Persistence** - Named volumes for all data
- ✅ **Network Security** - Isolated Docker network
- ✅ **Monitoring** - Health checks and status scripts
- ✅ **Scalability** - Modular service architecture

## 📄 License

MIT License - see LICENSE file for details.

---

**Project Location**: `/Volumes/NASté-DockerHD/|Projects (Holding)/GitHub/Active Repos/PostgresAI`  
**Created**: July 4, 2025  
**Updated**: July 4, 2025 - Added Tailscale integration and NAS deployment
