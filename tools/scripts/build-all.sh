#!/bin/bash

# Build All Services Script
# This script builds all services in the monorepo

set -e

echo "🚀 Building all services in the monorepo..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        exit 1
    fi
    
    if ! command -v pnpm &> /dev/null; then
        print_error "pnpm is not installed"
        exit 1
    fi
    
    if ! command -v go &> /dev/null; then
        print_warning "Go is not installed - skipping Go services"
    fi
    
    if ! command -v cargo &> /dev/null; then
        print_warning "Rust/Cargo is not installed - skipping Rust services"
    fi
    
    if ! command -v python3 &> /dev/null; then
        print_warning "Python3 is not installed - skipping Python services"
    fi
    
    if ! command -v mvn &> /dev/null; then
        print_warning "Maven is not installed - skipping Java services"
    fi
}

# Build Node.js services
build_nodejs_services() {
    print_status "Building Node.js services..."
    
    # Install dependencies
    pnpm install
    
    # Build frontend applications
    print_status "Building frontend applications..."
    pnpm run build:frontend
    
    # Build auth service
    print_status "Building auth service..."
    npx nx build auth-service
}

# Build Go services
build_go_services() {
    if command -v go &> /dev/null; then
        print_status "Building Go services..."
        cd apps/backend/payment-service
        go build -o payment-service main.go
        cd ../../..
        print_status "Go payment service built successfully"
    else
        print_warning "Skipping Go services - Go not installed"
    fi
}

# Build Rust services
build_rust_services() {
    if command -v cargo &> /dev/null; then
        print_status "Building Rust services..."
        cd apps/backend/analytics-service
        cargo build --release
        cd ../../..
        print_status "Rust analytics service built successfully"
    else
        print_warning "Skipping Rust services - Cargo not installed"
    fi
}

# Build Python services
build_python_services() {
    if command -v python3 &> /dev/null; then
        print_status "Building Python services..."
        cd apps/backend/ai-service
        if command -v uv &> /dev/null; then
            uv sync
        else
            pip install -r requirements.txt 2>/dev/null || print_warning "No requirements.txt found"
        fi
        cd ../../..
        print_status "Python AI service dependencies installed"
    else
        print_warning "Skipping Python services - Python3 not installed"
    fi
}

# Build Java services
build_java_services() {
    if command -v mvn &> /dev/null; then
        print_status "Building Java services..."
        cd apps/backend/pdf-service
        ./mvnw clean package -DskipTests
        cd ../../..
        print_status "Java PDF service built successfully"
    else
        print_warning "Skipping Java services - Maven not installed"
    fi
}

# Main build function
main() {
    print_status "Starting build process..."
    
    check_dependencies
    build_nodejs_services
    build_go_services
    build_rust_services
    build_python_services
    build_java_services
    
    print_status "✅ All services built successfully!"
    print_status "You can now run 'pnpm dev:all' to start all services"
}

# Run main function
main "$@"
