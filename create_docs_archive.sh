#!/bin/bash

# PostgresAI Documentation Archive Creator
# Creates a compressed file with complete container structure and documentation

echo "Creating PostgresAI Documentation Archive..."

# Create temporary documentation directory
DOCS_DIR="PostgresAI_Complete_Docs"
mkdir -p "$DOCS_DIR"

# Copy all configuration files
echo "Copying configuration files..."
cp docker-compose.yml "$DOCS_DIR/"
cp .env "$DOCS_DIR/main.env"
cp -r db/ "$DOCS_DIR/"
cp -r ollama/ "$DOCS_DIR/"
cp -r tinybert/ "$DOCS_DIR/"
cp -r nginx/ "$DOCS_DIR/"
cp -r docs/ "$DOCS_DIR/"

# Copy backup documentation
cp SETUP_BACKUP.md "$DOCS_DIR/"

# Create comprehensive container documentation
cat > "$DOCS_DIR/CONTAINER_STRUCTURE.md" << 'EOF'
# PostgresAI Container Structure Documentation

## Complete Directory Tree
```
PostgresAI/
├── docker-compose.yml              # Main orchestration file
├── .env                           # Environment variables
├── check_ports.sh                 # Port checking script
├── SETUP_BACKUP.md               # Complete backup guide
├── create_docs_archive.sh         # This documentation creator
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
    ├── deployment_instructions.md  # How to deploy
    ├── access_services.md         # Service access guide
    ├── troubleshoot.md            # Troubleshooting guide
    └── architecture_diagram.txt   # System architecture
```

## Container Network Architecture
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

## Volume Mapping
```
Named Volumes (Persistent):
├── postgres_data          → /var/lib/postgresql/data
├── pgadmin_data           → /var/lib/pgadmin
├── dbeaver_data           → /opt/cloudbeaver/workspace
├── open-webui-data        → /app/backend/data
├── ollama_data            → /root/.ollama
├── ollama_model_loader_data → /app/models
├── tinybert_models        → /app/models
├── tailscale_data         → /var/lib/tailscale
└── nginx_logs             → /var/log/nginx

Bind Mounts (Configuration):
├── ./db/init              → /docker-entrypoint-initdb.d
├── ./nginx/nginx.conf     → /etc/nginx/nginx.conf
├── ./nginx/ssl            → /etc/nginx/ssl
└── /dev/net/tun           → /dev/net/tun (Tailscale)
```

## Port Mapping
```
External → Internal (Service)
├── 65432 → 5432   (PostgreSQL)
├── 5051  → 80     (pgAdmin)
├── 8978  → 8978   (DBeaver)
├── 11434 → 11434  (Ollama)
├── 8081  → 8080   (OpenWebUI)
├── 8083  → 8083   (TinyBERT)
├── 80    → 80     (Nginx HTTP)
└── 443   → 443    (Nginx HTTPS)
```

## Service Dependencies
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

## Environment Variables by Service
```
Main (.env):
├── POSTGRES_DB=postgres_ai
├── POSTGRES_USER=postgres
├── POSTGRES_PASSWORD=your_secure_password
├── PGADMIN_EMAIL=admin@example.com
├── PGADMIN_PASSWORD=admin_password
├── WEBUI_SECRET_KEY=your_secret_key
├── FLASK_ENV=production
└── TS_AUTHKEY=your_tailscale_key

Database (db/.env):
└── POSTGRES_PASSWORD=your_secure_password

Ollama (ollama/.env):
├── OLLAMA_HOST=0.0.0.0
└── MODEL_NAME=deepseek:latest

TinyBERT (tinybert/app.env):
├── MODEL_NAME=distilbert-base-uncased
└── FLASK_ENV=production
```

## Resource Requirements
```
GPU Support:
└── Ollama: NVIDIA GPU with Docker runtime

Memory Recommendations:
├── PostgreSQL: 512MB-1GB
├── pgAdmin: 256MB
├── DBeaver: 512MB
├── Ollama: 4GB+ (model dependent)
├── OpenWebUI: 512MB
├── TinyBERT: 1GB
├── Nginx: 128MB
└── Tailscale: 64MB

Total Recommended: 8GB+ RAM
```

## Security Features
```
Network Isolation:
└── Custom bridge network (172.20.0.0/16)

SSL/TLS:
├── Nginx reverse proxy with SSL termination
└── SSL certificates in nginx/ssl/

VPN Access:
└── Tailscale for secure external connectivity

Container Security:
├── Non-root users where possible
├── Restart policies: unless-stopped
└── Limited capabilities and privileges
```

## Backup Strategy
```
Configuration Backup:
├── All Dockerfiles and compose files
├── Environment configurations
└── Initialization scripts

Data Backup:
├── postgres_data volume
├── pgadmin_data volume
├── ollama_data volume (models)
└── Application data volumes

Recovery Process:
1. Restore configuration files
2. Run: docker-compose up -d
3. Volumes auto-attach by name
```

Created: July 4, 2025
Version: 1.0
EOF

# Create file manifest
echo "Creating file manifest..."
cat > "$DOCS_DIR/FILE_MANIFEST.txt" << 'EOF'
PostgresAI Complete Documentation Archive
========================================

This archive contains the complete PostgresAI Docker container setup.

Contents:
---------
📁 Configuration Files:
   - docker-compose.yml         Main orchestration
   - main.env                   Environment variables
   
📁 Database (db/):
   - Dockerfile                 PostgreSQL custom image
   - .env                      Database environment
   - init/01-init.sql          Database initialization
   
📁 AI Services (ollama/):
   - Dockerfile                Ollama image
   - .env                      Ollama environment  
   - startup.sh                Container startup
   - model_loader.sh           Model management
   
📁 Transformers (tinybert/):
   - Dockerfile                TinyBERT image
   - app.env                   App environment
   - requirements.txt          Python dependencies
   - app/main.py               Flask application
   
📁 Reverse Proxy (nginx/):
   - nginx.conf                Nginx configuration
   - ssl/                      SSL certificates directory
   
📁 Documentation (docs/):
   - deployment_instructions.md Deploy guide
   - access_services.md        Access information
   - troubleshoot.md           Problem solving
   - architecture_diagram.txt  System overview
   
📁 Archive Documentation:
   - SETUP_BACKUP.md           Complete backup guide
   - CONTAINER_STRUCTURE.md    Detailed structure
   - FILE_MANIFEST.txt         This file

Quick Start:
-----------
1. Extract archive to desired location
2. Navigate to directory: cd PostgresAI
3. Configure .env files with your settings
4. Start services: docker-compose up -d

Services Access:
---------------
- PostgreSQL: localhost:65432
- pgAdmin: http://localhost:5051  
- DBeaver: http://localhost:8978
- OpenWebUI: http://localhost:8081
- Ollama: http://localhost:11434
- TinyBERT: http://localhost:8083

Support:
--------
Repository: https://github.com/jrblh75/PostgresAI
Created: July 4, 2025
EOF

# Create archive
echo "Creating compressed archive..."
tar -czf "PostgresAI_Complete_Documentation_$(date +%Y%m%d_%H%M%S).tar.gz" "$DOCS_DIR"

# Clean up temporary directory
rm -rf "$DOCS_DIR"

echo "✅ Documentation archive created successfully!"
echo "📦 File: PostgresAI_Complete_Documentation_$(date +%Y%m%d_%H%M%S).tar.gz"
echo ""
echo "Archive contains:"
echo "  • Complete container structure documentation"
echo "  • All configuration files and Dockerfiles"
echo "  • Environment templates"
echo "  • Deployment and troubleshooting guides"
echo "  • File manifest and setup instructions"
echo ""
echo "To extract: tar -xzf PostgresAI_Complete_Documentation_*.tar.gz"
