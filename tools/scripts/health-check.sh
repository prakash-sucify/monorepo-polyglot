#!/bin/bash

# Health Check Script
# This script checks the health of all services

set -e

echo "🏥 Checking service health..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_service() {
    echo -e "${BLUE}[SERVICE]${NC} $1"
}

# Function to check HTTP endpoint
check_http_endpoint() {
    local url=$1
    local service_name=$2
    local expected_status=${3:-200}
    
    print_service "Checking $service_name at $url"
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        print_status "✅ $service_name is healthy"
        return 0
    else
        print_error "❌ $service_name is not responding"
        return 1
    fi
}

# Function to check if port is listening
check_port() {
    local port=$1
    local service_name=$2
    
    print_service "Checking $service_name on port $port"
    
    if lsof -i :$port > /dev/null 2>&1; then
        print_status "✅ $service_name is listening on port $port"
        return 0
    else
        print_error "❌ $service_name is not listening on port $port"
        return 1
    fi
}

# Check all services
check_all_services() {
    local failed_services=0
    
    print_status "Starting health checks..."
    echo ""
    
    # Frontend services
    print_status "=== Frontend Services ==="
    check_http_endpoint "http://localhost:3000" "Web App" || ((failed_services++))
    check_http_endpoint "http://localhost:3001" "Admin Panel" || ((failed_services++))
    echo ""
    
    # Backend services
    print_status "=== Backend Services ==="
    check_http_endpoint "http://localhost:3002" "Auth Service" || ((failed_services++))
    check_http_endpoint "http://localhost:8080/health" "Payment Service" || ((failed_services++))
    check_http_endpoint "http://localhost:8081/health" "Analytics Service" || ((failed_services++))
    check_http_endpoint "http://localhost:8082/health" "AI Service" || ((failed_services++))
    check_http_endpoint "http://localhost:8083/health" "PDF Service" || ((failed_services++))
    echo ""
    
    # Port checks (backup)
    print_status "=== Port Checks ==="
    check_port 3000 "Web App" || ((failed_services++))
    check_port 3001 "Admin Panel" || ((failed_services++))
    check_port 3002 "Auth Service" || ((failed_services++))
    check_port 8080 "Payment Service" || ((failed_services++))
    check_port 8081 "Analytics Service" || ((failed_services++))
    check_port 8082 "AI Service" || ((failed_services++))
    check_port 8083 "PDF Service" || ((failed_services++))
    echo ""
    
    return $failed_services
}

# Check individual service
check_service() {
    local service=$1
    
    case $service in
        "web")
            check_http_endpoint "http://localhost:3000" "Web App"
            ;;
        "admin")
            check_http_endpoint "http://localhost:3001" "Admin Panel"
            ;;
        "auth")
            check_http_endpoint "http://localhost:3002" "Auth Service"
            ;;
        "payment")
            check_http_endpoint "http://localhost:8080/health" "Payment Service"
            ;;
        "analytics")
            check_http_endpoint "http://localhost:8081/health" "Analytics Service"
            ;;
        "ai")
            check_http_endpoint "http://localhost:8082/health" "AI Service"
            ;;
        "pdf")
            check_http_endpoint "http://localhost:8083/health" "PDF Service"
            ;;
        *)
            print_error "Unknown service: $service"
            print_status "Available services: web, admin, auth, payment, analytics, ai, pdf"
            exit 1
            ;;
    esac
}

# Main function
main() {
    if [ $# -eq 0 ]; then
        # Check all services
        check_all_services
        local failed_services=$?
        
        echo ""
        if [ $failed_services -eq 0 ]; then
            print_status "🎉 All services are healthy!"
        else
            print_error "⚠️  $failed_services service(s) are not healthy"
            exit 1
        fi
    else
        # Check specific service
        check_service "$1"
    fi
}

# Run main function
main "$@"
