#!/bin/bash

# Monorepo Polyglot Deployment Script for monorepo.sucify.com
# This script deploys the complete polyglot monorepo with domain configuration

set -e

echo "🚀 Starting Monorepo Polyglot Deployment for monorepo.sucify.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   exit 1
fi

# Check prerequisites
print_status "Checking prerequisites..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    print_error "pnpm is not installed. Please install pnpm first."
    exit 1
fi

print_success "All prerequisites are installed"

# Load environment variables
print_status "Loading environment variables..."
if [ -f "tools/configs/environments/production.env" ]; then
    source tools/configs/environments/production.env
    print_success "Production environment loaded"
else
    print_warning "Production environment file not found, using defaults"
fi

# Create SSL certificate directory if it doesn't exist
print_status "Setting up SSL certificates..."
if [ ! -d "ssl" ]; then
    mkdir -p ssl
fi

# Check if SSL certificates exist
if [ ! -f "ssl/monorepo.sucify.com.crt" ] || [ ! -f "ssl/monorepo.sucify.com.key" ]; then
    print_warning "SSL certificates not found. Creating self-signed certificates for development..."
    
    # Create self-signed certificate (for development only)
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/monorepo.sucify.com.key \
        -out ssl/monorepo.sucify.com.crt \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=monorepo.sucify.com"
    
    print_warning "Self-signed certificates created. For production, replace with real certificates."
else
    print_success "SSL certificates found"
fi

# Install dependencies
print_status "Installing dependencies..."
pnpm install
print_success "Dependencies installed"

# Build all services
print_status "Building all services..."
pnpm build:all
print_success "All services built"

# Stop existing containers
print_status "Stopping existing containers..."
docker-compose down || true
print_success "Existing containers stopped"

# Build and start all services
print_status "Building and starting all services..."
docker-compose --profile production up --build -d
print_success "All services started"

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 30

# Health check
print_status "Performing health checks..."

# Check if nginx is running
if curl -f -s http://localhost/health > /dev/null; then
    print_success "Nginx is running"
else
    print_warning "Nginx health check failed"
fi

# Check if web app is accessible
if curl -f -s http://localhost > /dev/null; then
    print_success "Web application is accessible"
else
    print_warning "Web application health check failed"
fi

# Display service URLs
print_success "Deployment completed successfully!"
echo ""
echo "🌐 Service URLs:"
echo "   Main Web App:     https://monorepo.sucify.com"
echo "   Admin Panel:      https://admin.monorepo.sucify.com"
echo "   API Gateway:      https://api.monorepo.sucify.com"
echo ""
echo "📊 Service Status:"
echo "   Web App:          http://localhost:3000"
echo "   Admin Panel:      http://localhost:3001"
echo "   Auth Service:     http://localhost:3002"
echo "   Payment Service:  http://localhost:8080"
echo "   Analytics Service: http://localhost:8081"
echo "   AI Service:       http://localhost:8082"
echo "   PDF Service:      http://localhost:8083"
echo ""
echo "🔧 Management Commands:"
echo "   View logs:        docker-compose --profile production logs -f"
echo "   Stop services:    docker-compose --profile production down"
echo "   Restart services: docker-compose --profile production restart"
echo "   Update services:  ./deploy.sh"
echo ""
print_success "Monorepo Polyglot is now running on monorepo.sucify.com! 🎉"
