#!/bin/bash

# PostgresAI Service Test Script
echo "🚀 PostgresAI Service Test Script"
echo "=================================="
echo

# Test TinyBERT Health
echo "🧠 Testing TinyBERT Health..."
if curl -s -f http://localhost:8083/health > /dev/null; then
    echo "✅ TinyBERT is healthy"
    curl -s http://localhost:8083/health | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8083/health
else
    echo "❌ TinyBERT is not responding"
fi
echo

# Test PostgreSQL
echo "🗄️ Testing PostgreSQL..."
if docker exec postgres_ai pg_isready -U postgres > /dev/null 2>&1; then
    echo "✅ PostgreSQL is ready"
else
    echo "❌ PostgreSQL is not ready"
fi
echo

# Test TinyBERT Embedding (simple test)
echo "🔍 Testing TinyBERT Embedding API..."
if curl -s -f -X POST http://localhost:8083/embed \
    -H "Content-Type: application/json" \
    -d '{"text":"Hello World"}' > /dev/null; then
    echo "✅ TinyBERT Embedding API is working"
else
    echo "❌ TinyBERT Embedding API is not working (may be loading model)"
fi
echo

# Show running containers
echo "📦 Running Containers:"
docker compose ps
echo

echo "✨ Test complete! Check the guide files:"
echo "   - USER_GUIDE.md (comprehensive guide)"
echo "   - QUICK_REFERENCE.md (quick commands)"
