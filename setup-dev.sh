#!/bin/bash

# Monorepo Polyglot Development Setup Script
# This script sets up the development environment for local development

set -e

echo "🚀 Setting up Monorepo Polyglot Development Environment"

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

# Check prerequisites
print_status "Checking prerequisites..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    print_error "pnpm is not installed. Please install pnpm first."
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

print_success "All prerequisites are installed"

# Install dependencies
print_status "Installing dependencies..."
pnpm install
print_success "Dependencies installed"

# Set up environment variables
print_status "Setting up environment variables..."
if [ ! -f ".env" ]; then
    cp tools/configs/environments/development.env .env
    print_success "Development environment file created"
else
    print_warning "Environment file already exists"
fi

# Build all services
print_status "Building all services..."
pnpm build:all
print_success "All services built"

# Start development environment
print_status "Starting development environment..."
print_status "This will start all services in development mode..."
echo ""
echo "🌐 Development URLs:"
echo "   Main Web App:     http://localhost:3000"
echo "   Admin Panel:      http://localhost:3001"
echo "   Auth Service:     http://localhost:3002"
echo "   Payment Service:  http://localhost:8080"
echo "   Analytics Service: http://localhost:8081"
echo "   AI Service:       http://localhost:8082"
echo "   PDF Service:      http://localhost:8083"
echo ""
echo "🔧 Available Commands:"
echo "   Start all:        pnpm dev:all"
echo "   Start frontend:   pnpm dev:web && pnpm dev:admin"
echo "   Start backend:    pnpm dev:backend"
echo "   Run tests:        pnpm test"
echo "   Build:            pnpm build:all"
echo ""

# Ask user if they want to start services now
read -p "Do you want to start all services now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Starting all services..."
    pnpm dev:all
else
    print_success "Setup completed! Run 'pnpm dev:all' to start all services."
fi
