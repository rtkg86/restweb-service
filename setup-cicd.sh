#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  CI/CD Setup Script - Jenkins & SonarQube                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "✅ Docker found"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker Compose found"

echo ""
echo "Starting CI/CD services..."
echo ""

# Start services
docker-compose up -d

echo ""
echo "Waiting for services to start..."
sleep 10

# Check service status
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Service Status                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

docker-compose ps

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Access Information                                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "📋 SonarQube"
echo "  URL: http://localhost:9000"
echo "  Default Credentials: admin / admin"
echo "  (Change password on first login)"
echo ""

echo "🔧 Jenkins"
echo "  URL: http://localhost:8081"
echo "  Unlock password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "  (waiting for Jenkins to start...)"
echo ""

echo "📦 PostgreSQL"
echo "  Host: localhost"
echo "  Port: 5432"
echo "  Database: sonarqube"
echo "  Username: sonar"
echo "  Password: sonar"
echo ""

echo "📖 Next Steps:"
echo "  1. Access SonarQube at http://localhost:9000"
echo "  2. Create a security token in SonarQube"
echo "  3. Configure Jenkins at http://localhost:8081"
echo "  4. Add SonarQube token to Jenkins credentials"
echo "  5. Create a new Pipeline job pointing to your Jenkinsfile"
echo ""

echo "💡 Useful Commands:"
echo "  View logs: docker-compose logs -f sonarqube"
echo "  Stop services: docker-compose stop"
echo "  Start services: docker-compose start"
echo "  Restart services: docker-compose restart"
echo "  Remove all: docker-compose down -v"
echo ""

echo "📖 For detailed setup instructions, see CICD_SETUP.md"
echo ""

