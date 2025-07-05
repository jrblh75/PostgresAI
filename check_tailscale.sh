#!/bin/bash

# PostgresAI Tailscale Network Check Script
echo "======================================="
echo "PostgresAI Tailscale Network Status"
echo "======================================="

# Check if Tailscale Desktop is running
echo "1. Checking Tailscale Desktop status..."
if pgrep -f "Tailscale.app" > /dev/null; then
    echo "   ✅ Tailscale Desktop is running"
else
    echo "   ❌ Tailscale Desktop is not running"
fi

# Find Tailscale interface and IP
echo ""
echo "2. Tailscale Network Interface:"
TAILSCALE_IP=$(ifconfig | grep -A 1 "inet 100\." | grep "100\." | awk '{print $2}')
if [ ! -z "$TAILSCALE_IP" ]; then
    echo "   ✅ Tailscale IP: $TAILSCALE_IP"
    TAILSCALE_INTERFACE=$(ifconfig | grep -B 5 "$TAILSCALE_IP" | head -1 | cut -d: -f1)
    echo "   📡 Interface: $TAILSCALE_INTERFACE"
else
    echo "   ❌ No Tailscale IP found"
fi

# Check Docker network
echo ""
echo "3. Docker Network Status:"
if docker network ls | grep -q "postgres_ai_network"; then
    echo "   ✅ PostgresAI Docker network exists"
    DOCKER_SUBNET=$(docker network inspect postgresai_postgres_ai_network 2>/dev/null | grep -o '"Subnet": "[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$DOCKER_SUBNET" ]; then
        echo "   🌐 Docker subnet: $DOCKER_SUBNET"
    fi
else
    echo "   ⚠️  PostgresAI Docker network not found"
fi

# Check running containers
echo ""
echo "4. Container Status:"
if docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -q "postgres_ai\|tailscale_ai"; then
    echo "   📦 PostgresAI Containers:"
    docker ps --format "   {{.Names}}: {{.Status}}" | grep -E "(postgres_ai|tailscale_ai|pgadmin_ai|nginx_ssl)"
else
    echo "   ⚠️  No PostgresAI containers running"
fi

# Show access URLs
echo ""
echo "5. Service Access URLs:"
if [ ! -z "$TAILSCALE_IP" ]; then
    echo "   🌐 Via Tailscale Network ($TAILSCALE_IP):"
    echo "     • PostgreSQL: $TAILSCALE_IP:65432"
    echo "     • pgAdmin: http://$TAILSCALE_IP:5051"
    echo "     • DBeaver: http://$TAILSCALE_IP:8978"
    echo "     • OpenWebUI: http://$TAILSCALE_IP:8081"
    echo "     • TinyBERT: http://$TAILSCALE_IP:8083"
    echo "     • Nginx: http://$TAILSCALE_IP"
fi

echo ""
echo "   🏠 Via Local Network:"
echo "     • PostgreSQL: localhost:65432"
echo "     • pgAdmin: http://localhost:5051"
echo "     • DBeaver: http://localhost:8978"
echo "     • OpenWebUI: http://localhost:8081"
echo "     • TinyBERT: http://localhost:8083"
echo "     • Nginx: http://localhost"

echo ""
echo "======================================="
echo "Next Steps:"
echo "1. Update TS_AUTHKEY in .env file"
echo "2. Run: docker-compose up -d"
echo "3. Access services via Tailscale IP from any device"
echo "======================================="
