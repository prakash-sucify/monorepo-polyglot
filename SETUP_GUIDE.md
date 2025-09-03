# 🚀 Monorepo Polyglot - Complete Setup Guide

A comprehensive guide to set up and run all services in your polyglot monorepo.

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Step 1: Clone and Setup](#-step-1-clone-and-setup)
- [Step 2: Individual Service Setup](#-step-2-individual-service-setup)
- [Step 3: Frontend Applications](#-step-3-frontend-applications)
- [Step 4: Docker Setup](#-step-4-docker-setup-recommended)
- [Step 5: Quick Start Commands](#-step-5-quick-start-commands)
- [Step 6: Testing](#-step-6-testing)
- [Step 7: Verification](#-step-7-verification)
- [Step 8: Development Workflow](#-step-8-development-workflow)
- [Troubleshooting](#-troubleshooting)
- [Service Architecture](#-service-architecture)
- [Quick Reference](#-quick-reference)

## 📋 Prerequisites

### Required Software

Check if you have these installed:

```bash
node --version    # Should be v18+
pnpm --version    # Package manager
docker --version  # For containerized services
java --version    # Should be Java 17+
go version        # For Go services
rustc --version   # For Rust services
python --version  # Should be Python 3.10+
uv --version      # Python package manager
```

### Install Missing Dependencies

```bash
# Install Node.js and pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
source ~/.bashrc  # or ~/.zshrc

# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Rust (if not installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Install Go (if not installed)
# Download from https://golang.org/dl/
# Or use package manager: brew install go (macOS)
```

## 🏗️ Step 1: Clone and Setup

```bash
# Clone the repository (if not already done)
git clone <your-repo-url>
cd monorepo-polyglot

# Install root dependencies
pnpm install
```

## 🔧 Step 2: Individual Service Setup

### 2.1 Node.js Auth Service

```bash
# Already configured - uses root dependencies
cd apps/backend/auth-service

# Test build
npx nx build auth-service

# Run the service
npx nx serve auth-service
# OR
node dist/auth-service/main.js

# Test: curl http://localhost:3000
```

### 2.2 Python AI Service

```bash
cd apps/backend/ai-service

# Install Python dependencies
uv sync

# Run the service
uv run python src/ai_service_python/main.py

# Test: curl http://localhost:8082
```

### 2.3 Rust Analytics Service

```bash
cd apps/backend/analytics-service

# Build the service
cargo build

# Run the service
cargo run

# Test: curl http://localhost:8081
```

### 2.4 Go Payment Service

```bash
cd apps/backend/payment-service

# Download dependencies
go mod tidy

# Build the service
go build

# Run the service
go run main.go

# Test: curl http://localhost:8080
```

### 2.5 Java PDF Service

```bash
cd apps/backend/pdf-service

# Build the service
./mvnw clean compile

# Run the service
./mvnw spring-boot:run

# Test: curl http://localhost:8083
```

## 🌐 Step 3: Frontend Applications

### 3.1 Web Application

```bash
cd apps/frontend/web

# Run the web app
npx nx serve web
# OR from root: pnpm dev:web

# Access: http://localhost:3000
```

### 3.2 Admin Panel

```bash
cd apps/frontend/admin

# Run the admin panel
npx nx serve admin
# OR from root: pnpm dev:admin

# Access: http://localhost:3001
```

## 🐳 Step 4: Docker Setup (Recommended)

### 4.1 Using Docker Compose

```bash
# From root directory
docker-compose up --build

# This will start all services:
# - Web app: http://localhost:3000
# - Admin panel: http://localhost:3001
# - Auth service: http://localhost:3002
# - Payment service: http://localhost:8080
# - Analytics service: http://localhost:8081
# - AI service: http://localhost:8082
# - PDF service: http://localhost:8083
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379
```

### 4.2 Individual Docker Services

```bash
# Build individual services
docker build -t auth-service apps/backend/auth-service/
docker build -t ai-service apps/backend/ai-service/
docker build -t analytics-service apps/backend/analytics-service/
docker build -t payment-service apps/backend/payment-service/
docker build -t pdf-service apps/backend/pdf-service/
```

## ⚡ Step 5: Quick Start Commands

### 5.1 Run Everything at Once

```bash
# From root directory - run all services
pnpm dev:all

# This runs:
# - Web app (port 3000)
# - Admin panel (port 3001) 
# - Auth service (port 3002)
# - All backend services
```

### 5.2 Run Specific Categories

```bash
# Frontend only
pnpm dev:web      # Web app
pnpm dev:admin    # Admin panel

# Backend only
pnpm dev:backend  # All backend services
pnpm dev:auth     # Auth service only
```

## 🧪 Step 6: Testing

### 6.1 Unit Tests

```bash
# Run all tests
pnpm test

# Frontend tests
pnpm test:frontend

# Backend tests
pnpm test:backend

# Individual service tests
npx nx test web
npx nx test admin
npx nx test auth-service
```

### 6.2 E2E Tests

```bash
# Run E2E tests
npx nx e2e web-e2e
npx nx e2e admin-e2e
npx nx e2e auth-service-e2e

# Open Cypress UI
npx nx open-cypress web-e2e
```

## 🔍 Step 7: Verification

### 7.1 Check All Services

```bash
# Test all endpoints
curl http://localhost:3000  # Web app
curl http://localhost:3001  # Admin panel
curl http://localhost:3002  # Auth service
curl http://localhost:8080  # Payment service
curl http://localhost:8081  # Analytics service
curl http://localhost:8082  # AI service
curl http://localhost:8083  # PDF service
```

### 7.2 Health Checks

```bash
# Check if all processes are running
ps aux | grep -E "(node|python|java|go|rust)"

# Check ports
lsof -i :3000  # Web
lsof -i :3001  # Admin
lsof -i :3002  # Auth
lsof -i :8080  # Payment
lsof -i :8081  # Analytics
lsof -i :8082  # AI
lsof -i :8083  # PDF
```

## 🛠️ Step 8: Development Workflow

### 8.1 Daily Development

```bash
# Start development environment
pnpm dev:all

# In separate terminals for specific services:
cd apps/backend/ai-service && uv run python src/ai_service_python/main.py
cd apps/backend/analytics-service && cargo run
cd apps/backend/payment-service && go run main.go
cd apps/backend/pdf-service && ./mvnw spring-boot:run
```

### 8.2 Code Quality

```bash
# Lint all code
pnpm lint

# Lint specific projects
pnpm lint:frontend
pnpm lint:backend

# Build all projects
pnpm build
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Conflicts

```bash
# Kill processes on specific ports
lsof -ti:3000 | xargs kill -9
lsof -ti:8080 | xargs kill -9
```

#### 2. Dependency Issues

```bash
# Clean and reinstall
pnpm clean
rm -rf node_modules
pnpm install
```

#### 3. Docker Issues

```bash
# Reset Docker
docker-compose down
docker system prune -a
docker-compose up --build
```

#### 4. Java Service Issues

```bash
# Clean Maven cache
cd apps/backend/pdf-service
./mvnw clean
./mvnw spring-boot:run
```

#### 5. Python Service Issues

```bash
# Reinstall Python dependencies
cd apps/backend/ai-service
uv lock --upgrade
uv sync
```

#### 6. Rust Service Issues

```bash
# Clean and rebuild Rust service
cd apps/backend/analytics-service
cargo clean
cargo build
```

#### 7. Go Service Issues

```bash
# Clean Go modules
cd apps/backend/payment-service
go clean -modcache
go mod tidy
go build
```

## 📊 Service Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Web App       │    │   Admin Panel   │
│   (Next.js)     │    │   (Next.js)     │
│   Port: 3000    │    │   Port: 3001    │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────┬───────────┘
                     │
    ┌────────────────┼────────────────┐
    │                │                │
┌───▼───┐    ┌──────▼──────┐    ┌────▼────┐
│ Auth  │    │  Payment    │    │ Analytics│
│Service│    │  Service    │    │ Service  │
│Node.js│    │    Go       │    │  Rust    │
│:3002  │    │  :8080      │    │  :8081   │
└───────┘    └─────────────┘    └─────────┘
    │                │                │
    └────────────────┼────────────────┘
                     │
    ┌────────────────┼────────────────┐
    │                │                │
┌───▼───┐    ┌──────▼──────┐    ┌────▼────┐
│  AI   │    │    PDF      │    │Database │
│Service│    │  Service    │    │PostgreSQL│
│Python │    │   Java      │    │ :5432   │
│:8082  │    │  :8083      │    └─────────┘
└───────┘    └─────────────┘
```

## 🎯 Quick Reference

| Service | Technology | Port | Debug Port | Command |
|---------|------------|------|------------|---------|
| Web App | Next.js | 3000 | 9229 | `pnpm dev:web` |
| Admin | Next.js | 3001 | 9231 | `pnpm dev:admin` |
| Auth | Node.js | 3002 | 9230 | `pnpm dev:auth` |
| Payment | Go | 8080 | - | `go run main.go` |
| Analytics | Rust | 8081 | - | `cargo run` |
| AI | Python | 8082 | - | `uv run python src/ai_service_python/main.py` |
| PDF | Java | 8083 | - | `./mvnw spring-boot:run` |

## 🐛 Debugging

### Node.js Services Debug Ports

Each Node.js service has been configured with a unique debug port to avoid conflicts:

- **Web App**: `localhost:9229` (default)
- **Auth Service**: `localhost:9230`
- **Admin Panel**: `localhost:9231`

### Connecting Debugger

To debug any Node.js service:

1. **VS Code**: Add to `.vscode/launch.json`:
```json
{
  "type": "node",
  "request": "attach",
  "name": "Debug Auth Service",
  "port": 9230,
  "restart": true
}
```

2. **Chrome DevTools**: Open `chrome://inspect` and click "Open dedicated DevTools for Node"

3. **Command Line**: Use `node --inspect=9230` for specific port debugging

## 🚀 One-Command Setup

```bash
# Complete setup in one command
git clone <repo> && cd monorepo-polyglot && pnpm install && pnpm dev:all
```

## ✅ Test Results

The `pnpm dev:all` command has been tested and verified to work correctly. Here's the current status:

### ✅ Working Services

| Service | Technology | Port | Status | Health Check |
|---------|------------|------|--------|--------------|
| Web App | Next.js | 3000 | ✅ Running | `{"message":"Hello API"}` |
| Analytics | Rust | 8081 | ✅ Running | `{"service":"analytics-service","status":"healthy"}` |
| AI | Python | 8082 | ✅ Running | `{"status":"healthy","service":"ai-service","version":"1.0.0"}` |
| Payment | Go | 8080 | ✅ Running | `{"service":"payment-service","status":"healthy"}` |
| PDF | Java | 8083 | ✅ Running | Spring Boot 404 (service running, no root endpoint) |

### ✅ All Services Working

| Service | Technology | Port | Status | Health Check |
|---------|------------|------|--------|--------------|
| Admin Panel | Next.js | 3001 | ✅ Running | HTML page with NX welcome |
| Auth Service | Node.js | 3002 | ✅ Running | `{"message":"Hello API"}` |

### 🔧 Fixed Issues

1. **Go Payment Service**: Fixed syntax error in `main.go` (removed "ba" prefix)
2. **Auth Service Port Conflict**: Changed default port from 3000 to 3002 to avoid conflict with web app
3. **Frontend Project Configuration**: Added missing NX serve targets for `web` and `admin` projects
4. **Debug Port Conflicts**: Configured unique debug ports for each Node.js service:
   - Web App: Port 9229 (default)
   - Auth Service: Port 9230
   - Admin Panel: Port 9231
5. **All Services**: Successfully running and responding to health checks
6. **Concurrently**: Working correctly to start all services simultaneously

## 🎉 **Final Status: ALL SERVICES WORKING!**

The `pnpm dev:all` command now successfully starts all 7 services:
- ✅ **Web App** (Next.js) - Port 3000
- ✅ **Admin Panel** (Next.js) - Port 3001  
- ✅ **Auth Service** (Node.js) - Port 3002
- ✅ **Payment Service** (Go) - Port 8080
- ✅ **Analytics Service** (Rust) - Port 8081
- ✅ **AI Service** (Python) - Port 8082
- ✅ **PDF Service** (Java) - Port 8083

## 📝 Available Scripts

### Root Package Scripts

```bash
# Development
pnpm dev              # Start web app
pnpm dev:web          # Start web app
pnpm dev:admin        # Start admin panel
pnpm dev:auth         # Start auth service
pnpm dev:backend      # Start all backend services
pnpm dev:all          # Start everything

# Building
pnpm build            # Build all projects
pnpm build:frontend   # Build frontend projects
pnpm build:backend    # Build backend projects

# Testing
pnpm test             # Run all tests
pnpm test:frontend    # Run frontend tests
pnpm test:backend     # Run backend tests

# Linting
pnpm lint             # Lint all projects
pnpm lint:frontend    # Lint frontend projects
pnpm lint:backend     # Lint backend projects

# Docker
pnpm docker:up        # Start all services with Docker
pnpm docker:down      # Stop Docker services
pnpm docker:logs      # View Docker logs

# Maintenance
pnpm clean            # Clean cache and reinstall
```

### NX Commands

```bash
# Project management
npx nx show projects                    # List all projects
npx nx show project <project-name>     # Show project details
npx nx graph                           # Show project dependency graph

# Running services
npx nx serve web                       # Serve web app
npx nx serve admin                     # Serve admin panel
npx nx serve auth-service              # Serve auth service

# Building
npx nx build web                       # Build web app
npx nx build admin                     # Build admin panel
npx nx build auth-service              # Build auth service

# Testing
npx nx test web                        # Test web app
npx nx test admin                      # Test admin panel
npx nx test auth-service               # Test auth service

# E2E Testing
npx nx e2e web-e2e                     # Run web E2E tests
npx nx e2e admin-e2e                   # Run admin E2E tests
npx nx e2e auth-service-e2e            # Run auth E2E tests
```

## 🔧 Environment Variables

### Required Environment Variables

Create `.env` files in the respective service directories:

#### Auth Service (`apps/backend/auth-service/.env`)
```env
NODE_ENV=development
PORT=3002
JWT_SECRET=your_jwt_secret_here
DATABASE_URL=postgresql://user:password@localhost:5432/auth_db
```

#### Payment Service (`apps/backend/payment-service/.env`)
```env
PORT=8080
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
```

#### AI Service (`apps/backend/ai-service/.env`)
```env
PORT=8082
OPENAI_API_KEY=your_openai_api_key
```

## 📚 Additional Resources

- [NX Documentation](https://nx.dev/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Axum Documentation](https://docs.rs/axum/)
- [Gin Documentation](https://gin-gonic.com/docs/)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `pnpm test`
5. Run linting: `pnpm lint`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Happy Coding! 🎉**

For any issues or questions, please check the troubleshooting section or create an issue in the repository.
