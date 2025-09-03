#!/bin/bash

# Local Deployment Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check Docker Compose
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not available. Please install Docker with Compose support."
        exit 1
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi
    
    # Check pnpm
    if ! command -v pnpm &> /dev/null; then
        print_error "pnpm is not installed. Please install pnpm first."
        exit 1
    fi
    
    print_status "✅ All prerequisites are installed"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    # Install Node.js dependencies
    pnpm install
    
    print_status "✅ Dependencies installed"
}

# Start services with Docker
start_docker() {
    print_status "Starting services with Docker Compose..."
    
    # Start all services
    pnpm docker:up
    
    print_status "✅ Services started with Docker"
}

# Start services locally
start_local() {
    print_status "Starting services locally..."
    
    # Start all services
    pnpm dev:all
    
    print_status "✅ Services started locally"
}

# Start services with Kubernetes
start_k8s() {
    print_status "Starting services with Kubernetes..."
    
    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    # Check if minikube is running
    if ! minikube status &> /dev/null; then
        print_warning "Minikube is not running. Starting minikube..."
        minikube start
    fi
    
    # Apply Kubernetes manifests
    pnpm k8s:apply
    
    print_status "✅ Services started with Kubernetes"
}

# Health check
health_check() {
    print_status "Running health checks..."
    
    # Wait for services to start
    sleep 10
    
    # Check web app
    if curl -s http://localhost:3000/api/health > /dev/null; then
        print_status "✅ Web app is healthy"
    else
        print_warning "⚠️ Web app is not responding"
    fi
    
    # Check auth service
    if curl -s http://localhost:3002/health > /dev/null; then
        print_status "✅ Auth service is healthy"
    else
        print_warning "⚠️ Auth service is not responding"
    fi
    
    # Check payment service
    if curl -s http://localhost:8080/health > /dev/null; then
        print_status "✅ Payment service is healthy"
    else
        print_warning "⚠️ Payment service is not responding"
    fi
    
    # Check analytics service
    if curl -s http://localhost:8081/health > /dev/null; then
        print_status "✅ Analytics service is healthy"
    else
        print_warning "⚠️ Analytics service is not responding"
    fi
    
    # Check AI service
    if curl -s http://localhost:8082/health > /dev/null; then
        print_status "✅ AI service is healthy"
    else
        print_warning "⚠️ AI service is not responding"
    fi
    
    # Check PDF service
    if curl -s http://localhost:8083/health > /dev/null; then
        print_status "✅ PDF service is healthy"
    else
        print_warning "⚠️ PDF service is not responding"
    fi
}

# Show service URLs
show_urls() {
    print_info "🌐 Service URLs:"
    echo "  Web App:        http://localhost:3000"
    echo "  Admin Panel:    http://localhost:3001"
    echo "  Auth Service:   http://localhost:3002"
    echo "  Payment Service: http://localhost:8080"
    echo "  Analytics Service: http://localhost:8081"
    echo "  AI Service:     http://localhost:8082"
    echo "  PDF Service:    http://localhost:8083"
    echo "  PostgreSQL:     localhost:5432"
    echo "  Redis:          localhost:6379"
    echo ""
    print_info "🔧 Useful Commands:"
    echo "  View logs:      pnpm docker:logs"
    echo "  Stop services:  pnpm docker:down"
    echo "  Health check:   pnpm health:check"
    echo "  Run tests:      pnpm test"
    echo "  Security scan:  pnpm security:scan"
}

# Stop services
stop_services() {
    print_status "Stopping services..."
    
    # Stop Docker services
    pnpm docker:down
    
    # Stop Kubernetes services
    if command -v kubectl &> /dev/null; then
        pnpm k8s:delete 2>/dev/null || true
    fi
    
    print_status "✅ Services stopped"
}

# Clean up
cleanup() {
    print_status "Cleaning up..."
    
    # Stop services
    stop_services
    
    # Clean Docker
    docker system prune -f
    
    # Clean build artifacts
    pnpm clean:all
    
    print_status "✅ Cleanup completed"
}

# Show usage
show_usage() {
    echo "Local Deployment Script"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  docker     Start services with Docker Compose (recommended)"
    echo "  local      Start services locally (development)"
    echo "  k8s        Start services with Kubernetes"
    echo "  stop       Stop all services"
    echo "  health     Run health checks"
    echo "  urls       Show service URLs"
    echo "  cleanup    Stop services and clean up"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 docker    # Start with Docker (recommended)"
    echo "  $0 local     # Start locally for development"
    echo "  $0 k8s       # Start with Kubernetes"
    echo "  $0 stop      # Stop all services"
    echo "  $0 health    # Check service health"
    echo "  $0 urls      # Show service URLs"
}

# Main execution
main() {
    case "${1:-help}" in
        docker)
            check_prerequisites
            install_dependencies
            start_docker
            health_check
            show_urls
            ;;
        local)
            check_prerequisites
            install_dependencies
            start_local
            health_check
            show_urls
            ;;
        k8s)
            check_prerequisites
            install_dependencies
            start_k8s
            health_check
            show_urls
            ;;
        stop)
            stop_services
            ;;
        health)
            health_check
            ;;
        urls)
            show_urls
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
