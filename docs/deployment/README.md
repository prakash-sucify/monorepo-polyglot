# Deployment Guide

This guide covers deployment strategies and configurations for the polyglot monorepo across different environments.

## 🚀 Deployment Overview

The monorepo supports multiple deployment strategies:
- **Local Development**: Docker Compose with hot reloading
- **Staging**: Containerized services with shared infrastructure
- **Production**: Kubernetes with auto-scaling and high availability

## 🏗️ Environment Configurations

### Development Environment

**Purpose**: Local development with hot reloading and debugging

**Configuration**:
- All services run locally on different ports
- Docker Compose for databases and Redis
- Environment file: `tools/configs/environments/development.env`

**Deployment**:
```bash
# Start all services
pnpm dev:all

# Or start with Docker Compose
docker-compose -f docker-compose.yml -f tools/configs/docker-compose.override.yml up
```

### Staging Environment

**Purpose**: Pre-production testing with production-like setup

**Configuration**:
- Containerized services
- Shared database and Redis instances
- Environment file: `tools/configs/environments/staging.env`

**Deployment**:
```bash
# Build and deploy to staging
./tools/scripts/build-all.sh
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d
```

### Production Environment

**Purpose**: High-availability production deployment

**Configuration**:
- Kubernetes deployment
- Database clustering
- Load balancing and auto-scaling
- Environment file: `tools/configs/environments/production.env`

## 🐳 Docker Deployment

### Local Development with Docker

1. **Start infrastructure services**:
```bash
docker-compose up postgres redis -d
```

2. **Start application services**:
```bash
pnpm dev:all
```

### Full Docker Deployment

1. **Build all services**:
```bash
./tools/scripts/build-all.sh
```

2. **Start all services**:
```bash
docker-compose up -d
```

3. **Check service health**:
```bash
./tools/scripts/health-check.sh
```

### Docker Compose Files

- `docker-compose.yml`: Base configuration
- `tools/configs/docker-compose.override.yml`: Development overrides
- `docker-compose.staging.yml`: Staging configuration
- `docker-compose.prod.yml`: Production configuration

## ☸️ Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (v1.24+)
- kubectl configured
- Helm (optional, for package management)

### Deployment Steps

1. **Create namespace**:
```bash
kubectl create namespace monorepo-polyglot
```

2. **Apply configurations**:
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/services/
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/ingress.yaml
```

3. **Verify deployment**:
```bash
kubectl get pods -n monorepo-polyglot
kubectl get services -n monorepo-polyglot
```

### Kubernetes Manifests

```
k8s/
├── namespace.yaml
├── configmap.yaml
├── secrets.yaml
├── ingress.yaml
├── services/
│   ├── web-service.yaml
│   ├── admin-service.yaml
│   ├── auth-service.yaml
│   ├── payment-service.yaml
│   ├── analytics-service.yaml
│   ├── ai-service.yaml
│   └── pdf-service.yaml
└── deployments/
    ├── web-deployment.yaml
    ├── admin-deployment.yaml
    ├── auth-deployment.yaml
    ├── payment-deployment.yaml
    ├── analytics-deployment.yaml
    ├── ai-deployment.yaml
    └── pdf-deployment.yaml
```

## 🔧 Build and Deployment Scripts

### Build Script

The `tools/scripts/build-all.sh` script builds all services:

```bash
#!/bin/bash
# Builds all services in the monorepo
./tools/scripts/build-all.sh
```

**Features**:
- Checks for required dependencies
- Builds Node.js services with NX
- Builds Go services with `go build`
- Builds Rust services with `cargo build`
- Installs Python dependencies with `uv`
- Builds Java services with Maven

### Clean Script

The `tools/scripts/clean.sh` script cleans all build artifacts:

```bash
#!/bin/bash
# Cleans all build artifacts
./tools/scripts/clean.sh
```

**Features**:
- Removes node_modules and dist directories
- Cleans Go build cache
- Removes Rust target directories
- Cleans Python artifacts
- Removes Java target directories
- Cleans Docker artifacts

### Health Check Script

The `tools/scripts/health-check.sh` script verifies service health:

```bash
#!/bin/bash
# Check all services
./tools/scripts/health-check.sh

# Check specific service
./tools/scripts/health-check.sh auth
```

## 🌍 Environment Variables

### Development Environment

```bash
# Load development environment
source tools/configs/environments/development.env
```

### Staging Environment

```bash
# Load staging environment
source tools/configs/environments/staging.env
```

### Production Environment

```bash
# Load production environment
source tools/configs/environments/production.env
```

### Environment Variable Categories

1. **Service URLs**: Base URLs for all services
2. **Database Configuration**: PostgreSQL connection details
3. **Redis Configuration**: Redis connection details
4. **JWT Configuration**: Authentication settings
5. **API Keys**: Third-party service keys
6. **Logging**: Log level and format settings
7. **Security**: CORS, rate limiting, and security settings

## 📊 Monitoring and Observability

### Health Checks

All services provide health check endpoints:

- **Web App**: `GET /api/health`
- **Admin Panel**: `GET /api/health`
- **Auth Service**: `GET /health`
- **Payment Service**: `GET /health`
- **Analytics Service**: `GET /health`
- **AI Service**: `GET /health`
- **PDF Service**: `GET /health`

### Logging

**Structured Logging**:
- JSON format in production
- Pretty format in development
- Centralized log aggregation

**Log Levels**:
- `debug`: Development
- `info`: Staging
- `warn`: Production

### Metrics

**Service Metrics**:
- Request count and duration
- Error rates
- Resource utilization
- Business metrics

**Infrastructure Metrics**:
- CPU and memory usage
- Disk I/O
- Network traffic
- Database performance

## 🔒 Security Considerations

### Secrets Management

**Development**:
- Environment files (not committed)
- Local configuration

**Staging/Production**:
- Kubernetes secrets
- External secret management (HashiCorp Vault, AWS Secrets Manager)

### Network Security

- Service-to-service communication over internal networks
- TLS encryption for external communication
- Network policies for pod-to-pod communication

### Container Security

- Non-root user in containers
- Minimal base images
- Security scanning in CI/CD pipeline
- Regular image updates

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build and Deploy
        run: |
          ./tools/scripts/build-all.sh
          ./tools/scripts/deploy.sh
```

### Deployment Pipeline

1. **Code Checkout**: Get latest code
2. **Dependency Installation**: Install all dependencies
3. **Testing**: Run unit and integration tests
4. **Building**: Build all services
5. **Security Scanning**: Scan for vulnerabilities
6. **Deployment**: Deploy to target environment
7. **Health Checks**: Verify deployment success
8. **Rollback**: Automatic rollback on failure

## 📈 Scaling Strategies

### Horizontal Scaling

**Frontend Services**:
- Multiple replicas behind load balancer
- CDN for static assets
- Edge caching

**Backend Services**:
- Auto-scaling based on CPU/memory
- Database connection pooling
- Redis clustering

### Vertical Scaling

- Increase container resources
- Optimize application performance
- Database query optimization

## 🔄 Rollback Procedures

### Automatic Rollback

- Health check failures trigger rollback
- Previous version deployment
- Database migration rollback

### Manual Rollback

```bash
# Rollback to previous version
kubectl rollout undo deployment/service-name -n monorepo-polyglot

# Check rollback status
kubectl rollout status deployment/service-name -n monorepo-polyglot
```

## 📋 Deployment Checklist

### Pre-Deployment

- [ ] Code review completed
- [ ] Tests passing
- [ ] Security scan passed
- [ ] Environment variables configured
- [ ] Database migrations ready
- [ ] Backup procedures in place

### Deployment

- [ ] Deploy to staging first
- [ ] Run smoke tests
- [ ] Deploy to production
- [ ] Monitor health checks
- [ ] Verify all services running
- [ ] Check logs for errors

### Post-Deployment

- [ ] Monitor metrics and logs
- [ ] Verify user functionality
- [ ] Check performance metrics
- [ ] Update documentation
- [ ] Notify stakeholders

## 🆘 Troubleshooting

### Common Issues

1. **Service Not Starting**:
   - Check logs: `kubectl logs deployment/service-name`
   - Verify environment variables
   - Check resource limits

2. **Database Connection Issues**:
   - Verify connection string
   - Check network policies
   - Verify credentials

3. **High Memory Usage**:
   - Check for memory leaks
   - Increase resource limits
   - Optimize application code

### Debug Commands

```bash
# Check pod status
kubectl get pods -n monorepo-polyglot

# View logs
kubectl logs -f deployment/service-name -n monorepo-polyglot

# Execute into pod
kubectl exec -it pod-name -n monorepo-polyglot -- /bin/bash

# Check service endpoints
kubectl get endpoints -n monorepo-polyglot
```

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NX Documentation](https://nx.dev/)
- [Monitoring Best Practices](monitoring.md)
- [Security Guidelines](security.md)
