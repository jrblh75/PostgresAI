# PostgresAI User Guide

## Getting Started

This guide walks you through setting up and using PostgresAI.

## Prerequisites

- Docker and Docker Compose
- 4GB+ RAM
- 10GB+ free disk space

## Installation

1. Clone the repository:
```bash
git clone https://github.com/jrblh75/PostgresAI.git
cd PostgresAI
```

2. Start the services:
```bash
./start_postgresai.sh
```

## Accessing Services

- Database: localhost:5432
- Web UI: https://localhost:8443

## Configuration Options

### Environment Variables

Configure the system by editing the `.env` file:

```
POSTGRES_VERSION=17.5
POSTGRES_USER=postgres_admin
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=postgres_ai
```

### Database Configuration

The database is pre-configured with optimal settings for AI workloads.

## Troubleshooting

See `docs/troubleshoot.md` for common issues and solutions.

## Backup and Recovery

Regular backups are recommended. Use the provided scripts:

```bash
./create_docs_archive.sh
```

## Security Considerations

- Change default passwords
- Restrict network access
- Use SSL for connections
