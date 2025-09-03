# 🚀 Polyglot Monorepo

A comprehensive monorepo built with NX containing multiple services in different programming languages, demonstrating polyglot architecture patterns and industry best practices.

## 🏗️ Architecture

This monorepo follows industry-standard practices with clear separation of frontend and backend applications:

### Frontend Applications (`apps/frontend/`)
- **Web App** (`web/`) - Main customer-facing React application with Next.js, TypeScript, and Tailwind CSS
- **Admin Panel** (`admin/`) - Administrative dashboard for managing the platform

### Backend Services (`apps/backend/`)
- **Auth Service** (`auth-service/`) - Node.js/Express authentication service
- **Payment Service** (`payment-service/`) - Go service with Stripe integration
- **Analytics Service** (`analytics-service/`) - Rust service for event tracking and analytics
- **AI Service** (`ai-service/`) - Python/FastAPI service with OpenAI integration
- **PDF Service** (`pdf-service/`) - Java/Spring Boot service for PDF manipulation using PDFBox

### Shared Libraries (`apps/shared/` & `libs/shared/`)
- **API Client** (`apps/shared/api-client/`) - Shared API client for all services
- **Validation** (`apps/shared/validation/`) - Shared validation schemas and utilities
- **Constants** (`apps/shared/constants/`) - Shared constants and configuration
- **Utils** (`apps/shared/utils/`) - Shared utility functions
- **UI Components** (`libs/shared/ui-components/`) - Reusable React components
- **Types** (`libs/shared/types/`) - Shared TypeScript type definitions

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- pnpm
- Docker & Docker Compose
- Go 1.21+
- Rust (latest stable)
- Python 3.11+
- Java 17+
- Maven 3.9+

### Environment Setup

1. **Clone and install dependencies:**
   ```bash
   git clone <repository-url>
   cd monorepo-polyglot
   pnpm install
   ```

2. **Set up environment variables:**
   ```bash
   # Copy development environment
   cp tools/configs/environments/development.env .env
   
   # Edit the .env file with your actual API keys
   nano .env
   ```

3. **Start all services:**
   ```bash
   pnpm dev:all
   ```

## 🛠️ Development Tools

### Build Scripts
```bash
# Build all services
pnpm build:all

# Clean all build artifacts
pnpm clean:all

# Check service health
pnpm health:check
```

### Individual Service Development

#### Frontend Applications
```bash
# Web App (Main customer-facing app)
pnpm dev:web
# Runs on http://localhost:3000

# Admin Panel
pnpm dev:admin
# Runs on http://localhost:3001
```

#### Backend Services
```bash
# Auth Service
pnpm dev:auth
# Runs on http://localhost:3002

# All Backend Services
pnpm dev:backend
# Runs all backend services on ports 8080-8083
```

### NX Commands
```bash
# Serve individual services
nx serve web
nx serve admin
nx serve auth-service

# Build services
nx build web
nx build admin
nx build auth-service

# Run tests
nx test web
nx test admin
nx test auth-service

# Run linting
nx lint web
nx lint admin
nx lint auth-service
```

## 🐳 Docker

### Build and Run All Services
```bash
docker-compose up --build
```

### Run Individual Services
```bash
# Frontend
docker-compose up web admin

# Auth service
docker-compose up auth-service

# Payment service
docker-compose up payment-service

# Analytics service
docker-compose up analytics-service

# AI service
docker-compose up ai-service

# PDF service
docker-compose up pdf-service
```

## 🧪 Testing

### Frontend Testing
```bash
# Unit tests
pnpm test:frontend

# E2E tests
nx e2e web-e2e
nx e2e admin-e2e
```

### Backend Service Testing
Each service has its own testing setup:
- **Auth Service**: Jest
- **Payment Service**: Go testing
- **Analytics Service**: Cargo test
- **AI Service**: pytest
- **PDF Service**: JUnit

### Health Checks
```bash
# Check all services
./tools/scripts/health-check.sh

# Check specific service
./tools/scripts/health-check.sh auth
```

## 📦 Project Structure

```
monorepo-polyglot/
├── apps/
│   ├── frontend/              # Frontend applications
│   │   ├── web/              # Main web application (Next.js)
│   │   ├── admin/            # Admin panel (Next.js)
│   │   ├── web-e2e/          # Web app E2E tests (Cypress)
│   │   └── admin-e2e/        # Admin panel E2E tests (Cypress)
│   ├── backend/              # Backend services
│   │   ├── auth-service/     # Node.js/Express auth service
│   │   ├── payment-service/  # Go payment service
│   │   ├── analytics-service/# Rust analytics service
│   │   ├── ai-service/       # Python/FastAPI AI service
│   │   ├── pdf-service/      # Java/Spring Boot PDF service
│   │   └── auth-service-e2e/ # Auth service E2E tests (Jest)
├── libs/                     # Shared libraries
│   ├── api-client/          # API client utilities
│   ├── validation/          # Validation schemas
│   ├── constants/           # Shared constants
│   ├── utils/              # Utility functions
│   ├── types/              # TypeScript types
│   └── ui-components/      # Reusable UI components
├── tools/                    # Build tools and scripts
│   ├── scripts/              # Build and utility scripts
│   │   ├── build-all.sh      # Build all services
│   │   ├── clean.sh          # Clean build artifacts
│   │   ├── health-check.sh   # Health check script
│   │   └── local-deploy.sh   # Local deployment script
│   └── configs/              # Configuration files
├── docs/                     # Documentation
│   ├── architecture/         # Architecture docs
│   ├── api/                  # API documentation
│   ├── deployment/           # Deployment guides
│   └── development/          # Development guides
└── docker-compose.yml        # Docker orchestration
```

## 🌍 Environment Management

### Development
```bash
# Load development environment
source tools/configs/environments/development.env
```

### Staging
```bash
# Load staging environment
source tools/configs/environments/staging.env
```

### Production
```bash
# Load production environment
source tools/configs/environments/production.env
```

## 📊 Service URLs

| Environment | Web App | Admin Panel | Auth Service | Payment Service | Analytics Service | AI Service | PDF Service |
|-------------|---------|-------------|--------------|-----------------|-------------------|------------|-------------|
| Development | http://localhost:3000 | http://localhost:3001 | http://localhost:3002 | http://localhost:8080 | http://localhost:8081 | http://localhost:8082 | http://localhost:8083 |
| Staging | https://staging-web.yourdomain.com | https://staging-admin.yourdomain.com | https://staging-auth.yourdomain.com | https://staging-payment.yourdomain.com | https://staging-analytics.yourdomain.com | https://staging-ai.yourdomain.com | https://staging-pdf.yourdomain.com |
| Production | https://yourdomain.com | https://admin.yourdomain.com | https://auth.yourdomain.com | https://payment.yourdomain.com | https://analytics.yourdomain.com | https://ai.yourdomain.com | https://pdf.yourdomain.com |

## 🔧 Technology Stack

### Frontend
- **Framework**: Next.js 15.2.5
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: React Context / Zustand
- **Testing**: Jest, Cypress

### Backend Services

#### Auth Service (Node.js)
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Authentication**: JWT
- **Database**: PostgreSQL
- **Validation**: Joi
- **Security**: Helmet, CORS

#### Payment Service (Go)
- **Language**: Go 1.21+
- **Framework**: Gin
- **Payment Processing**: Stripe
- **Database**: PostgreSQL
- **Testing**: Go testing

#### Analytics Service (Rust)
- **Language**: Rust (latest stable)
- **Framework**: Axum
- **Database**: PostgreSQL
- **Testing**: Cargo test

#### AI Service (Python)
- **Language**: Python 3.11+
- **Framework**: FastAPI
- **AI/ML**: OpenAI API
- **Package Manager**: uv
- **Testing**: pytest

#### PDF Service (Java)
- **Language**: Java 17+
- **Framework**: Spring Boot 3.3.5
- **PDF Processing**: PDFBox 3.x
- **Build Tool**: Maven
- **Testing**: JUnit

### Infrastructure
- **Containerization**: Docker, Docker Compose
- **Build System**: NX
- **Package Management**: pnpm (Node.js), uv (Python), Cargo (Rust), Maven (Java)
- **Database**: PostgreSQL
- **Cache**: Redis
- **Monitoring**: Prometheus, Grafana (planned)

## 📚 Documentation

- [Architecture Guide](docs/architecture/README.md) - System architecture and design principles
- [API Documentation](docs/api/README.md) - Comprehensive API documentation
- [Deployment Guide](docs/deployment/README.md) - Deployment strategies and configurations
- [Development Guide](docs/development/README.md) - Development setup and workflow

## 🚀 Deployment

### Production Build
```bash
# Build all services
pnpm build:all

# Build Docker images
docker-compose -f docker-compose.prod.yml build
```

### Environment Variables for Production
Make sure to set the following environment variables:
- `STRIPE_SECRET_KEY` - Stripe API key
- `OPENAI_API_KEY` - OpenAI API key
- `JWT_SECRET` - JWT signing secret
- `DATABASE_URL` - PostgreSQL connection string

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Troubleshooting

### Common Issues

1. **Port conflicts**: Make sure ports 3000-3002 and 8080-8083 are available
2. **Docker issues**: Try `docker-compose down` and `docker-compose up --build`
3. **Dependencies**: Run `pnpm install` in the root directory
4. **Service not starting**: Check logs with `docker-compose logs service-name`

### Debug Commands

```bash
# Check service health
./tools/scripts/health-check.sh

# View service logs
docker-compose logs -f service-name

# Clean and rebuild
./tools/scripts/clean.sh
pnpm install
pnpm build:all
```

## 🎯 Features

- ✅ **Polyglot Architecture**: Multiple languages for optimal performance
- ✅ **Microservices Pattern**: Independent, scalable services
- ✅ **Monorepo Benefits**: Unified tooling and code sharing
- ✅ **Industry Best Practices**: NX workspace, proper testing, documentation
- ✅ **Docker Support**: Containerized deployment
- ✅ **Environment Management**: Development, staging, production configs
- ✅ **Comprehensive Testing**: Unit, integration, and E2E tests
- ✅ **API Documentation**: Complete API reference
- ✅ **Build Tools**: Automated build and deployment scripts
- ✅ **Health Monitoring**: Service health checks and monitoring

## 🔮 Future Enhancements

- [ ] Kubernetes deployment
- [ ] Service mesh (Istio)
- [ ] Event-driven architecture
- [ ] GraphQL API gateway
- [ ] Real-time notifications
- [ ] Advanced monitoring
- [ ] Multi-region deployment