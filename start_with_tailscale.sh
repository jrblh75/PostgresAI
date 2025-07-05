#!/bin/bash

# PostgresAI Tailscale Setup Script
echo "================================================="
echo "PostgresAI with Tailscale Network Setup"
echo "================================================="

# Check if Tailscale Desktop is running
if ! pgrep -f "Tailscale.app" > /dev/null; then
    echo "❌ Error: Tailscale Desktop is not running!"
    echo "Please start Tailscale Desktop first."
    exit 1
fi

# Get Tailscale IP
TAILSCALE_IP=$(ifconfig | grep -A 1 "inet 100\." | grep "100\." | awk '{print $2}')
if [ -z "$TAILSCALE_IP" ]; then
    echo "❌ Error: No Tailscale IP found!"
    echo "Please ensure Tailscale is properly connected."
    exit 1
fi

echo "✅ Tailscale Desktop is running"
echo "🌐 Your Tailscale IP: $TAILSCALE_IP"
echo ""

# Check if TS_AUTHKEY is set
if grep -q "your_tailscale_auth_key_here" .env; then
    echo "⚠️  Warning: TS_AUTHKEY not set in .env file"
    echo "To get your auth key:"
    echo "1. Go to https://login.tailscale.com/admin/settings/keys"
    echo "2. Generate a new auth key"
    echo "3. Update .env file: TS_AUTHKEY=your_actual_key_here"
    echo ""
    read -p "Continue without Tailscale container? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    SKIP_TAILSCALE=true
fi

# Stop any running containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Start services
echo "🚀 Starting PostgresAI services..."
if [ "$SKIP_TAILSCALE" = true ]; then
    # Start without Tailscale container
    docker-compose up -d postgres pgadmin dbeaver ollama open-webui tinybert nginx
else
    # Start all services including Tailscale
    docker-compose up -d
fi

# Wait a moment for services to start
echo "⏳ Waiting for services to start..."
sleep 10

# Check status
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "================================================="
echo "🎉 PostgresAI is ready!"
echo "================================================="
echo ""
echo "🌐 Access via Tailscale Network ($TAILSCALE_IP):"
echo "   • PostgreSQL: $TAILSCALE_IP:65432"
echo "   • pgAdmin: http://$TAILSCALE_IP:5051"
echo "   • DBeaver: http://$TAILSCALE_IP:8978"
echo "   • OpenWebUI: http://$TAILSCALE_IP:8081"
echo "   • TinyBERT: http://$TAILSCALE_IP:8083"
echo "   • Nginx Proxy: http://$TAILSCALE_IP"
echo ""
echo "🏠 Access via Local Network:"
echo "   • PostgreSQL: localhost:65432"
echo "   • pgAdmin: http://localhost:5051"
echo "   • DBeaver: http://localhost:8978"
echo "   • OpenWebUI: http://localhost:8081"
echo "   • TinyBERT: http://localhost:8083"
echo "   • Nginx Proxy: http://localhost"
echo ""
echo "📱 From any device on your Tailnet:"
echo "   Access all services using the Tailscale IP above!"
echo ""
echo "================================================="
