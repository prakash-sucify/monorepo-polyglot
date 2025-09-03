#!/bin/bash

# Clean Script
# This script cleans all build artifacts and temporary files

set -e

echo "🧹 Cleaning monorepo..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Clean Node.js artifacts
clean_nodejs() {
    print_status "Cleaning Node.js artifacts..."
    
    # Remove node_modules
    if [ -d "node_modules" ]; then
        rm -rf node_modules
        print_status "Removed node_modules"
    fi
    
    # Remove dist directories
    if [ -d "dist" ]; then
        rm -rf dist
        print_status "Removed dist directory"
    fi
    
    # Remove .next directories
    find . -name ".next" -type d -exec rm -rf {} + 2>/dev/null || true
    print_status "Removed .next directories"
    
    # Remove nx cache
    npx nx reset 2>/dev/null || true
    print_status "Reset NX cache"
}

# Clean Go artifacts
clean_go() {
    print_status "Cleaning Go artifacts..."
    
    # Remove Go binaries
    find . -name "*-service" -type f -exec rm -f {} + 2>/dev/null || true
    find . -name "payment-service" -type f -exec rm -f {} + 2>/dev/null || true
    
    # Remove Go build cache
    if command -v go &> /dev/null; then
        go clean -cache 2>/dev/null || true
        print_status "Cleaned Go build cache"
    fi
}

# Clean Rust artifacts
clean_rust() {
    print_status "Cleaning Rust artifacts..."
    
    # Remove target directories
    find . -name "target" -type d -exec rm -rf {} + 2>/dev/null || true
    print_status "Removed Rust target directories"
}

# Clean Python artifacts
clean_python() {
    print_status "Cleaning Python artifacts..."
    
    # Remove __pycache__ directories
    find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    
    # Remove .pyc files
    find . -name "*.pyc" -type f -exec rm -f {} + 2>/dev/null || true
    
    # Remove .pyo files
    find . -name "*.pyo" -type f -exec rm -f {} + 2>/dev/null || true
    
    # Remove .pyd files
    find . -name "*.pyd" -type f -exec rm -f {} + 2>/dev/null || true
    
    # Remove .egg-info directories
    find . -name "*.egg-info" -type d -exec rm -rf {} + 2>/dev/null || true
    
    print_status "Cleaned Python artifacts"
}

# Clean Java artifacts
clean_java() {
    print_status "Cleaning Java artifacts..."
    
    # Remove target directories
    find . -name "target" -type d -exec rm -rf {} + 2>/dev/null || true
    print_status "Removed Java target directories"
}

# Clean Docker artifacts
clean_docker() {
    print_status "Cleaning Docker artifacts..."
    
    # Stop and remove containers
    docker-compose down 2>/dev/null || true
    
    # Remove unused images
    docker image prune -f 2>/dev/null || true
    
    # Remove unused volumes
    docker volume prune -f 2>/dev/null || true
    
    print_status "Cleaned Docker artifacts"
}

# Clean temporary files
clean_temp() {
    print_status "Cleaning temporary files..."
    
    # Remove tmp directories
    if [ -d "tmp" ]; then
        rm -rf tmp
        print_status "Removed tmp directory"
    fi
    
    # Remove .DS_Store files (macOS)
    find . -name ".DS_Store" -type f -exec rm -f {} + 2>/dev/null || true
    
    # Remove Thumbs.db files (Windows)
    find . -name "Thumbs.db" -type f -exec rm -f {} + 2>/dev/null || true
    
    print_status "Cleaned temporary files"
}

# Main clean function
main() {
    print_status "Starting clean process..."
    
    clean_nodejs
    clean_go
    clean_rust
    clean_python
    clean_java
    clean_docker
    clean_temp
    
    print_status "✅ Clean completed successfully!"
    print_status "Run 'pnpm install' to reinstall dependencies"
}

# Run main function
main "$@"
