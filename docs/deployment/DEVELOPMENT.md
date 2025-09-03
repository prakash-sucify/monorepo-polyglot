# Development Guide

This guide provides detailed instructions for developing and contributing to the polyglot monorepo.

## 🏗️ Project Structure

```
monorepo-polyglot/
├── frontend/                    # Next.js frontend application
├── auth-service/               # Node.js/Express authentication service
├── services/
│   ├── payment-service-go/     # Go payment service with Stripe
│   ├── analytics-service-rust/ # Rust analytics service
│   ├── ai-service-python/      # Python/FastAPI AI service
│   └── pdf-service-java/       # Java/Spring Boot PDF service
├── docker-compose.yml          # Docker Compose configuration
├── nx.json                     # Nx workspace configuration
└── package.json               # Root package.json with scripts
```

## 🚀 Getting Started

### Prerequisites Installation

#### macOS (using Homebrew)
```bash
# Install Node.js and pnpm
brew install node pnpm

# Install Go
brew install go

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Python and uv
brew install python
pip install uv

# Install Java and Maven
brew install openjdk maven

# Install Docker
brew install --cask docker
```

#### Ubuntu/Debian
```bash
# Install Node.js and pnpm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g pnpm

# Install Go
sudo apt-get install golang-go

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Python and uv
sudo apt-get install python3 python3-pip
pip install uv

# Install Java and Maven
sudo apt-get install openjdk-17-jdk maven

# Install Docker
sudo apt-get install docker.io docker-compose
```

### Environment Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd monorepo-polyglot
   ```

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

3. **Set up environment variables:**
   ```bash
   # Copy environment files
   cp services/payment-service-go/env.example services/payment-service-go/.env
   cp services/ai-service-python/env.example services/ai-service-python/.env
   
   # Edit the .env files with your actual API keys
   nano services/payment-service-go/.env
   nano services/ai-service-python/.env
   ```

## 🛠️ Development Workflow

### Running Services Individually

#### Frontend Development
```bash
# Start the Next.js frontend
pnpm dev
# or
nx serve frontend

# The frontend will be available at http://localhost:3000
```

#### Auth Service Development
```bash
# Start the Node.js auth service
nx serve auth-service

# The auth service will be available at http://localhost:3001
```

#### Payment Service Development
```bash
cd services/payment-service-go

# Install dependencies
go mod tidy

# Run the service
go run main.go

# The payment service will be available at http://localhost:8080
```

#### Analytics Service Development
```bash
cd services/analytics-service-rust

# Run the service
cargo run

# The analytics service will be available at http://localhost:8081
```

#### AI Service Development
```bash
cd services/ai-service-python

# Install dependencies
uv sync

# Run the service
uv run python src/ai_service_python/main.py

# The AI service will be available at http://localhost:8082
```

#### PDF Service Development
```bash
cd services/pdf-service-java

# Run the service
mvn spring-boot:run

# The PDF service will be available at http://localhost:8083
```

### Running All Services

#### Using Docker Compose (Recommended)
```bash
# Start all services with Docker
pnpm docker:up

# View logs
pnpm docker:logs

# Stop all services
pnpm docker:down
```

#### Using Concurrently (Development)
```bash
# Start all services locally
pnpm dev:all
```

## 🧪 Testing

### Frontend Testing
```bash
cd frontend

# Unit tests
pnpm test

# E2E tests
pnpm test:e2e

# Test coverage
pnpm test:coverage
```

### Backend Service Testing

#### Auth Service
```bash
cd auth-service
pnpm test
```

#### Payment Service
```bash
cd services/payment-service-go
go test ./...
```

#### Analytics Service
```bash
cd services/analytics-service-rust
cargo test
```

#### AI Service
```bash
cd services/ai-service-python
uv run pytest
```

#### PDF Service
```bash
cd services/pdf-service-java
mvn test
```

### Running All Tests
```bash
# Run all Nx tests
pnpm test

# Run tests for specific services
nx test frontend
nx test auth-service
```

## 🔧 Code Quality

### Linting
```bash
# Lint all projects
pnpm lint

# Lint specific project
nx lint frontend
nx lint auth-service
```

### Formatting
```bash
# Format all code
nx format:write

# Check formatting
nx format:check
```

### Type Checking
```bash
# Type check all TypeScript projects
nx run-many --target=type-check --all
```

## 🐳 Docker Development

### Building Individual Services
```bash
# Build frontend
docker build -f frontend/Dockerfile -t frontend .

# Build auth service
docker build -f auth-service/Dockerfile -t auth-service .

# Build payment service
docker build -f services/payment-service-go/Dockerfile -t payment-service ./services/payment-service-go

# Build analytics service
docker build -f services/analytics-service-rust/Dockerfile -t analytics-service ./services/analytics-service-rust

# Build AI service
docker build -f services/ai-service-python/Dockerfile -t ai-service ./services/ai-service-python

# Build PDF service
docker build -f services/pdf-service-java/Dockerfile -t pdf-service ./services/pdf-service-java
```

### Docker Compose Commands
```bash
# Start specific services
docker-compose up frontend auth-service

# Rebuild and start
docker-compose up --build

# View logs for specific service
docker-compose logs -f frontend

# Execute commands in running container
docker-compose exec frontend sh
```

## 📦 Adding New Services

### Adding a Node.js Service
```bash
# Generate new Node.js service
nx g @nx/node:app <service-name> --framework=express

# Add to docker-compose.yml
# Add to package.json scripts
```

### Adding a Service in Another Language

1. **Create directory structure:**
   ```bash
   mkdir -p services/<service-name>-<language>
   cd services/<service-name>-<language>
   ```

2. **Initialize the project:**
   ```bash
   # For Go
   go mod init <service-name>
   
   # For Rust
   cargo init --name <service-name>
   
   # For Python
   uv init
   
   # For Java
   mvn archetype:generate -DgroupId=com.<service-name> -DartifactId=<service-name>
   ```

3. **Add to docker-compose.yml**
4. **Add to package.json scripts**
5. **Create Dockerfile**
6. **Update documentation**

## 🔍 Debugging

### Frontend Debugging
```bash
# Start with debugging enabled
nx serve frontend --verbose

# Use browser dev tools
# Set breakpoints in VS Code
```

### Backend Service Debugging

#### Node.js Services
```bash
# Start with debugging
node --inspect-brk dist/main.js

# Attach VS Code debugger
# Use Chrome DevTools: chrome://inspect
```

#### Go Services
```bash
# Start with debugging
dlv debug main.go

# Use VS Code Go extension
# Set breakpoints in VS Code
```

#### Rust Services
```bash
# Start with debugging
cargo run

# Use VS Code Rust extension
# Set breakpoints in VS Code
```

#### Python Services
```bash
# Start with debugging
uv run python -m debugpy --listen 5678 --wait-for-client src/ai_service_python/main.py

# Attach VS Code debugger
```

#### Java Services
```bash
# Start with debugging
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

# Attach VS Code debugger
```

## 📊 Monitoring and Logging

### Application Logs
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f frontend
docker-compose logs -f auth-service
```

### Health Checks
All services provide health check endpoints:
- Frontend: `http://localhost:3000/api/health`
- Auth Service: `http://localhost:3001/health`
- Payment Service: `http://localhost:8080/health`
- Analytics Service: `http://localhost:8081/health`
- AI Service: `http://localhost:8082/health`
- PDF Service: `http://localhost:8083/api/pdf/health`

## 🚀 Deployment

### Production Build
```bash
# Build all services
pnpm build

# Build Docker images for production
docker-compose -f docker-compose.prod.yml build
```

### Environment Variables for Production
```bash
# Required environment variables
export STRIPE_SECRET_KEY="sk_live_..."
export OPENAI_API_KEY="sk-..."
export JWT_SECRET="your-secure-jwt-secret"
export DATABASE_URL="postgresql://user:password@host:5432/db"
```

## 🤝 Contributing

### Git Workflow
1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Add tests for new functionality
4. Run tests: `pnpm test`
5. Run linting: `pnpm lint`
6. Commit your changes: `git commit -m "Add your feature"`
7. Push to your branch: `git push origin feature/your-feature`
8. Create a pull request

### Code Style Guidelines
- Use TypeScript for all Node.js services
- Follow the existing code style in each language
- Add JSDoc comments for functions
- Write unit tests for new features
- Update documentation for API changes

## 🆘 Troubleshooting

### Common Issues

#### Port Conflicts
```bash
# Check what's using a port
lsof -i :3000
lsof -i :8080

# Kill process using port
kill -9 <PID>
```

#### Docker Issues
```bash
# Clean up Docker
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

#### Dependency Issues
```bash
# Clean and reinstall
pnpm clean

# For Go services
cd services/payment-service-go && go mod tidy

# For Rust services
cd services/analytics-service-rust && cargo clean && cargo build

# For Python services
cd services/ai-service-python && uv sync --reinstall

# For Java services
cd services/pdf-service-java && mvn clean install
```

### Getting Help
- Check service-specific logs: `docker-compose logs <service-name>`
- Review the main README.md
- Check individual service documentation
- Ensure all prerequisites are installed correctly
