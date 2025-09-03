# Local Deployment Guide

This guide covers deploying the monorepo-polyglot application locally for development and testing.

## 🚀 Quick Start

### Prerequisites

- **Docker** and **Docker Compose**
- **Node.js** 18+ and **pnpm**
- **Go** 1.21+
- **Rust** (latest stable)
- **Python** 3.11+ and **uv**
- **Java** 17+ and **Maven**
- **kubectl** (for Kubernetes deployment)

## 📋 Option 1: Docker Compose (Recommended)

### 1. Start All Services

```bash
# Start all services with Docker (recommended)
pnpm local:deploy

# Or use Docker Compose directly
pnpm docker:up

# View logs
pnpm docker:logs

# Stop all services
pnpm local:stop
```

### 2. Access Services

| Service | URL | Description |
|---------|-----|-------------|
| Web App | http://localhost:3000 | Main web application |
| Admin Panel | http://localhost:3001 | Admin dashboard |
| Auth Service | http://localhost:3002 | Authentication API |
| Payment Service | http://localhost:8080 | Payment processing |
| Analytics Service | http://localhost:8081 | Analytics API |
| AI Service | http://localhost:8082 | AI/ML services |
| PDF Service | http://localhost:8083 | PDF processing |
| PostgreSQL | localhost:5432 | Database |
| Redis | localhost:6379 | Cache |

### 3. Health Check

```bash
# Check all services
pnpm health:check

# Check specific service
curl http://localhost:3000/api/health
curl http://localhost:3002/health
```

## 📋 Option 2: Local Development

### 1. Install Dependencies

```bash
# Install Node.js dependencies
pnpm install

# Install Go dependencies
cd apps/backend/payment-service
go mod tidy
cd ../../..

# Install Rust dependencies
cd apps/backend/analytics-service
cargo build
cd ../../..

# Install Python dependencies
cd apps/backend/ai-service
uv sync
cd ../../..

# Install Java dependencies
cd apps/backend/pdf-service
./mvnw clean install
cd ../../..
```

### 2. Start Services Individually

#### Frontend Services
```bash
# Web App
pnpm dev:web
# or
nx serve web

# Admin Panel
pnpm dev:admin
# or
nx serve admin
```

#### Backend Services
```bash
# Auth Service
pnpm dev:auth
# or
nx serve auth-service

# Payment Service
cd apps/backend/payment-service
go run main.go

# Analytics Service
cd apps/backend/analytics-service
cargo run

# AI Service
cd apps/backend/ai-service
uv run python src/ai_service_python/main.py

# PDF Service
cd apps/backend/pdf-service
./mvnw spring-boot:run
```

### 3. Start All Services

```bash
# Start all services concurrently
pnpm dev:all
```

## 📋 Option 3: Kubernetes (Local)

### 1. Prerequisites

```bash
# Install minikube
brew install minikube  # macOS
# or
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start minikube
minikube start

# Enable ingress
minikube addons enable ingress
```

### 2. Deploy to Kubernetes

```bash
# Apply all Kubernetes manifests
pnpm k8s:apply

# Check deployment status
pnpm k8s:status

# View logs
kubectl logs -f deployment/web-deployment -n monorepo-polyglot
```

### 3. Access Services

```bash
# Get service URLs
minikube service list -n monorepo-polyglot

# Access web app
minikube service web-service -n monorepo-polyglot

# Access admin panel
minikube service admin-service -n monorepo-polyglot
```

## 🔧 Configuration

### Environment Variables

Create `.env.local` file:

```bash
# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=monorepo_dev
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=your-local-jwt-secret
JWT_EXPIRES_IN=24h

# API Keys (for testing)
STRIPE_SECRET_KEY=sk_test_your_stripe_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_key
OPENAI_API_KEY=sk-your-openai-key

# Email (for testing)
SMTP_USER=test@localhost
SMTP_PASS=test-password
```

### Docker Compose Override

Create `docker-compose.override.yml`:

```yaml
version: '3.8'

services:
  web:
    environment:
      - NODE_ENV=development
      - NEXT_PUBLIC_API_URL=http://localhost:3002
  
  admin:
    environment:
      - NODE_ENV=development
      - NEXT_PUBLIC_API_URL=http://localhost:3002
  
  auth-service:
    environment:
      - NODE_ENV=development
      - LOG_LEVEL=debug
  
  postgres:
    environment:
      - POSTGRES_DB=monorepo_dev
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
  
  redis:
    ports:
      - "6379:6379"
```

## 🧪 Testing

### Run Tests

```bash
# Run all tests
pnpm test

# Run frontend tests
pnpm test:frontend

# Run backend tests
pnpm test:backend

# Run E2E tests
nx e2e web-e2e
nx e2e admin-e2e
```

### Test Individual Services

```bash
# Test auth service
curl http://localhost:3002/health

# Test payment service
curl http://localhost:8080/health

# Test analytics service
curl http://localhost:8081/health

# Test AI service
curl http://localhost:8082/health

# Test PDF service
curl http://localhost:8083/health
```

## 🐛 Debugging

### Enable Debug Mode

```bash
# Start with debug ports
pnpm dev:all

# Debug ports:
# Web App: 9229
# Admin Panel: 9231
# Auth Service: 9230
```

### VS Code Debugging

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Web App",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "restart": true,
      "localRoot": "${workspaceFolder}/apps/frontend/web",
      "remoteRoot": "/app"
    },
    {
      "name": "Debug Auth Service",
      "type": "node",
      "request": "attach",
      "port": 9230,
      "restart": true,
      "localRoot": "${workspaceFolder}/apps/backend/auth-service",
      "remoteRoot": "/app"
    }
  ]
}
```

### Chrome DevTools

1. Open Chrome
2. Go to `chrome://inspect`
3. Click "Open dedicated DevTools for Node"
4. Connect to debug port

## 📊 Monitoring

### Start Monitoring Stack

```bash
# Start monitoring services
pnpm monitoring:up

# Access monitoring tools
open http://localhost:9090  # Prometheus
open http://localhost:3000  # Grafana (admin/admin)
open http://localhost:5601  # Kibana
```

### View Logs

```bash
# Docker logs
pnpm docker:logs

# Kubernetes logs
kubectl logs -f deployment/web-deployment -n monorepo-polyglot

# Specific service logs
kubectl logs -f deployment/auth-deployment -n monorepo-polyglot
```

## 🔒 Security

### Run Security Scans

```bash
# Run security scan
pnpm security:scan

# Generate secrets
pnpm secrets:generate

# Validate secrets
pnpm secrets:validate
```

### Test Security

```bash
# Test authentication
curl -X POST http://localhost:3002/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# Test authorization
curl -H "Authorization: Bearer <token>" http://localhost:3002/auth/profile
```

## 🚨 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
PORT=3001 pnpm dev:web
```

#### Database Connection Issues
```bash
# Check PostgreSQL status
docker ps | grep postgres

# Restart database
docker-compose restart postgres

# Check database logs
docker-compose logs postgres
```

#### Service Not Starting
```bash
# Check service logs
pnpm docker:logs

# Restart specific service
docker-compose restart web

# Rebuild service
docker-compose up --build web
```

#### Kubernetes Issues
```bash
# Check pod status
kubectl get pods -n monorepo-polyglot

# Describe pod
kubectl describe pod <pod-name> -n monorepo-polyglot

# Check events
kubectl get events -n monorepo-polyglot
```

### Reset Everything

```bash
# Stop all services
pnpm docker:down

# Clean up
pnpm clean:all

# Remove Docker images
docker system prune -a

# Restart
pnpm docker:up
```

## 📝 Development Workflow

### 1. Start Development

```bash
# Clone and setup
git clone <your-repo>
cd monorepo-polyglot
pnpm install

# Start all services
pnpm dev:all
```

### 2. Make Changes

```bash
# Edit code in your IDE
# Services will auto-reload

# Run tests
pnpm test

# Check linting
pnpm lint
```

### 3. Test Changes

```bash
# Test locally
curl http://localhost:3000/api/health

# Run E2E tests
nx e2e web-e2e
```

### 4. Deploy

```bash
# Build for production
pnpm build:all

# Deploy to staging
git push origin develop

# Deploy to production
git push origin main
```

## 🎯 Best Practices

### Development

- **Use Docker Compose** for local development
- **Enable hot reload** for faster development
- **Run tests** before committing
- **Use debug mode** for troubleshooting
- **Monitor logs** for issues

### Testing

- **Test all services** individually
- **Run E2E tests** for critical paths
- **Test security** endpoints
- **Validate data** flow between services

### Deployment

- **Use environment variables** for configuration
- **Test in staging** before production
- **Monitor deployment** status
- **Rollback** if issues occur

## 📞 Support

For local deployment issues:

1. **Check logs** for error messages
2. **Verify prerequisites** are installed
3. **Test services** individually
4. **Check port conflicts**
5. **Restart services** if needed

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [NX Documentation](https://nx.dev/)
