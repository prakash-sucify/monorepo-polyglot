# Development Guide

This guide provides comprehensive instructions for setting up and developing in the polyglot monorepo.

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** 18+ and **pnpm**
- **Docker** and **Docker Compose**
- **Go** 1.21+
- **Rust** (latest stable)
- **Python** 3.11+ and **uv**
- **Java** 17+ and **Maven**

### Installation

1. **Clone the repository**:
```bash
git clone <repository-url>
cd monorepo-polyglot
```

2. **Install dependencies**:
```bash
pnpm install
```

3. **Set up environment variables**:
```bash
cp tools/configs/environments/development.env .env
# Edit .env with your configuration
```

4. **Start all services**:
```bash
pnpm dev:all
```

## 🏗️ Project Structure

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
│   └── shared/               # Shared business logic
│       ├── api-client/       # API client library
│       ├── validation/       # Validation schemas
│       ├── constants/        # Shared constants
│       └── utils/            # Utility functions
├── libs/
│   └── shared/               # Shared libraries
│       ├── types/            # TypeScript types
│       └── ui-components/    # React components
├── tools/                    # Build tools and scripts
│   ├── scripts/              # Build and utility scripts
│   └── configs/              # Configuration files
├── docs/                     # Documentation
└── docker-compose.yml        # Docker orchestration
```

## 🛠️ Development Workflow

### Starting Development

1. **Start infrastructure services**:
```bash
docker-compose up postgres redis -d
```

2. **Start all application services**:
```bash
pnpm dev:all
```

3. **Or start services individually**:
```bash
# Frontend services
pnpm dev:web      # Web app on http://localhost:3000
pnpm dev:admin    # Admin panel on http://localhost:3001

# Backend services
pnpm dev:auth     # Auth service on http://localhost:3002
pnpm dev:backend  # All backend services
```

### Service URLs

| Service | URL | Description |
|---------|-----|-------------|
| Web App | http://localhost:3000 | Main customer-facing application |
| Admin Panel | http://localhost:3001 | Administrative dashboard |
| Auth Service | http://localhost:3002 | Authentication API |
| Payment Service | http://localhost:8080 | Payment processing API |
| Analytics Service | http://localhost:8081 | Analytics and tracking API |
| AI Service | http://localhost:8082 | AI/ML services API |
| PDF Service | http://localhost:8083 | PDF generation API |

## 🔧 Development Tools

### Build Scripts

```bash
# Build all services
./tools/scripts/build-all.sh

# Clean all build artifacts
./tools/scripts/clean.sh

# Check service health
./tools/scripts/health-check.sh
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

# Run E2E tests
nx e2e web-e2e
nx e2e admin-e2e
nx e2e auth-service-e2e
```

### Language-Specific Commands

#### Node.js Services
```bash
# Install dependencies
pnpm install

# Run tests
pnpm test

# Run linting
pnpm lint

# Build
pnpm build
```

#### Go Services
```bash
# Install dependencies
go mod tidy

# Run tests
go test ./...

# Build
go build -o service-name main.go

# Run
go run main.go
```

#### Rust Services
```bash
# Install dependencies
cargo build

# Run tests
cargo test

# Run
cargo run
```

#### Python Services
```bash
# Install dependencies
uv sync

# Run tests
uv run pytest

# Run
uv run python src/main.py
```

#### Java Services
```bash
# Install dependencies
./mvnw dependency:resolve

# Run tests
./mvnw test

# Build
./mvnw clean package

# Run
./mvnw spring-boot:run
```

## 🧪 Testing

### Frontend Testing

```bash
# Unit tests
nx test web
nx test admin

# E2E tests
nx e2e web-e2e
nx e2e admin-e2e

# Test coverage
nx test web --coverage
```

### Backend Testing

```bash
# Node.js services
nx test auth-service

# Go services
cd apps/backend/payment-service
go test ./...

# Rust services
cd apps/backend/analytics-service
cargo test

# Python services
cd apps/backend/ai-service
uv run pytest

# Java services
cd apps/backend/pdf-service
./mvnw test
```

### Integration Testing

```bash
# Start all services
pnpm dev:all

# Run integration tests
./tools/scripts/health-check.sh

# Test API endpoints
curl http://localhost:3002/health
curl http://localhost:8080/health
curl http://localhost:8081/health
curl http://localhost:8082/health
curl http://localhost:8083/health
```

## 🔍 Debugging

### Frontend Debugging

**Web App (Port 3000)**:
- Debug port: 9229
- Chrome DevTools: `chrome://inspect`
- VS Code: Attach to process

**Admin Panel (Port 3001)**:
- Debug port: 9231
- Chrome DevTools: `chrome://inspect`
- VS Code: Attach to process

### Backend Debugging

**Auth Service (Port 3002)**:
- Debug port: 9230
- VS Code: Attach to process
- Chrome DevTools: `chrome://inspect`

**Other Services**:
- Use language-specific debuggers
- Check logs for debugging information

### VS Code Configuration

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
      "restart": true
    },
    {
      "name": "Debug Admin Panel",
      "type": "node",
      "request": "attach",
      "port": 9231,
      "restart": true
    },
    {
      "name": "Debug Auth Service",
      "type": "node",
      "request": "attach",
      "port": 9230,
      "restart": true
    }
  ]
}
```

## 📝 Code Style and Standards

### TypeScript/JavaScript

- Use ESLint and Prettier
- Follow Airbnb style guide
- Use TypeScript strict mode
- Prefer functional programming

### Go

- Use `gofmt` for formatting
- Follow Go conventions
- Use `golint` for linting
- Write comprehensive tests

### Rust

- Use `rustfmt` for formatting
- Follow Rust conventions
- Use `clippy` for linting
- Write unit and integration tests

### Python

- Use Black for formatting
- Follow PEP 8 style guide
- Use `flake8` for linting
- Write docstrings for functions

### Java

- Use Google Java Style
- Follow Spring Boot conventions
- Use Checkstyle for linting
- Write Javadoc comments

## 🔄 Git Workflow

### Branch Strategy

- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: Feature branches
- `hotfix/*`: Hotfix branches

### Commit Messages

Follow conventional commits:

```
feat: add user authentication
fix: resolve payment processing bug
docs: update API documentation
test: add unit tests for auth service
refactor: improve error handling
```

### Pull Request Process

1. Create feature branch from `develop`
2. Make changes and write tests
3. Run all tests and linting
4. Create pull request
5. Code review and approval
6. Merge to `develop`

## 🐛 Troubleshooting

### Common Issues

#### Port Conflicts
```bash
# Check what's using a port
lsof -i :3000

# Kill process using port
kill -9 <PID>
```

#### Service Not Starting
```bash
# Check logs
docker-compose logs service-name

# Restart service
docker-compose restart service-name
```

#### Database Connection Issues
```bash
# Check database status
docker-compose ps postgres

# Connect to database
docker-compose exec postgres psql -U user -d auth_db
```

#### Dependency Issues
```bash
# Clean and reinstall
./tools/scripts/clean.sh
pnpm install
```

### Debug Commands

```bash
# Check service health
./tools/scripts/health-check.sh

# View service logs
docker-compose logs -f service-name

# Check running processes
ps aux | grep node
ps aux | grep go
ps aux | grep python
```

## 📚 Additional Resources

### Documentation

- [Architecture Guide](../architecture/README.md)
- [API Documentation](../api/README.md)
- [Deployment Guide](../deployment/README.md)

### External Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Express.js Documentation](https://expressjs.com/)
- [Go Documentation](https://golang.org/doc/)
- [Rust Documentation](https://doc.rust-lang.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [NX Documentation](https://nx.dev/)

### Community

- [GitHub Issues](https://github.com/your-org/monorepo-polyglot/issues)
- [Discord Channel](https://discord.gg/your-channel)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/monorepo-polyglot)

## 🤝 Contributing

### Getting Started

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Submit a pull request

### Development Guidelines

- Write clear, readable code
- Add tests for new features
- Update documentation
- Follow the established patterns
- Be respectful in discussions

### Code Review Process

- All changes require review
- Address feedback promptly
- Keep PRs focused and small
- Write descriptive commit messages
- Update tests and documentation
