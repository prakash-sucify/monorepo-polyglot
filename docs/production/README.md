# Production Deployment Guide

This guide covers deploying the monorepo-polyglot application to production environments.

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.24+)
- kubectl configured
- Helm (v3.0+)
- Docker registry access
- SSL certificates
- Domain configuration

### 1. Deploy to Kubernetes

```bash
# Apply all Kubernetes manifests
pnpm k8s:apply

# Check deployment status
pnpm k8s:status

# View logs
kubectl logs -f deployment/web-deployment -n monorepo-polyglot
```

### 2. Set up Monitoring

```bash
# Start monitoring stack
pnpm monitoring:up

# Access Grafana
open http://localhost:3000
# Username: admin, Password: admin
```

### 3. Configure Secrets

```bash
# Generate secrets
pnpm secrets:generate

# Encrypt for Kubernetes
pnpm secrets:encrypt

# Apply secrets
kubectl apply -f k8s/base/secrets.yaml
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment | `production` |
| `PORT` | Service port | Service-specific |
| `POSTGRES_HOST` | Database host | `postgres-service` |
| `REDIS_HOST` | Redis host | `redis-service` |
| `JWT_SECRET` | JWT signing secret | Required |
| `STRIPE_SECRET_KEY` | Stripe API key | Required |

### Resource Limits

| Service | CPU Request | CPU Limit | Memory Request | Memory Limit |
|---------|-------------|-----------|----------------|--------------|
| Web App | 100m | 500m | 256Mi | 512Mi |
| Admin Panel | 100m | 500m | 256Mi | 512Mi |
| Auth Service | 100m | 500m | 256Mi | 512Mi |
| Payment Service | 100m | 500m | 128Mi | 256Mi |
| Analytics Service | 100m | 500m | 128Mi | 256Mi |
| AI Service | 200m | 1000m | 256Mi | 1Gi |
| PDF Service | 200m | 1000m | 512Mi | 1Gi |

## 📊 Monitoring

### Prometheus Metrics

- **Service Health**: `up{job="service-name"}`
- **Request Rate**: `rate(http_requests_total[5m])`
- **Response Time**: `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
- **Error Rate**: `rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])`

### Grafana Dashboards

- **Monorepo Overview**: Complete system overview
- **Service Performance**: Individual service metrics
- **Infrastructure**: Node and cluster metrics
- **Database**: PostgreSQL and Redis metrics

### Alerting

Critical alerts are configured for:
- Service downtime
- High error rates (>10%)
- High response times (>1s)
- Resource exhaustion
- Database connectivity issues

## 🔒 Security

### Network Policies

- Restrictive ingress/egress rules
- Service-to-service communication only
- External API access through ingress

### Pod Security

- Non-root containers
- Read-only root filesystems
- Dropped capabilities
- Security contexts

### Secrets Management

- Encrypted at rest
- Rotated regularly
- External secrets operator
- Sealed secrets support

## 🚨 Troubleshooting

### Common Issues

#### Service Not Starting
```bash
# Check pod status
kubectl get pods -n monorepo-polyglot

# View pod logs
kubectl logs <pod-name> -n monorepo-polyglot

# Check events
kubectl get events -n monorepo-polyglot
```

#### Database Connection Issues
```bash
# Check database status
kubectl get pods -l app.kubernetes.io/name=postgres -n monorepo-polyglot

# Test connection
kubectl exec -it <postgres-pod> -n monorepo-polyglot -- psql -U postgres -d monorepo_prod
```

#### High Memory Usage
```bash
# Check resource usage
kubectl top pods -n monorepo-polyglot

# Scale up if needed
kubectl scale deployment <deployment-name> --replicas=3 -n monorepo-polyglot
```

### Log Analysis

```bash
# View application logs
kubectl logs -f deployment/web-deployment -n monorepo-polyglot

# Search logs
kubectl logs deployment/web-deployment -n monorepo-polyglot | grep ERROR

# Export logs
kubectl logs deployment/web-deployment -n monorepo-polyglot > web-logs.txt
```

## 📈 Scaling

### Horizontal Scaling

```bash
# Scale web app
kubectl scale deployment web-deployment --replicas=5 -n monorepo-polyglot

# Scale auth service
kubectl scale deployment auth-deployment --replicas=3 -n monorepo-polyglot
```

### Vertical Scaling

Update resource limits in deployment manifests:

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

### Auto-scaling

```bash
# Create HPA for web app
kubectl autoscale deployment web-deployment --cpu-percent=70 --min=2 --max=10 -n monorepo-polyglot
```

## 🔄 Updates and Rollbacks

### Rolling Updates

```bash
# Update image
kubectl set image deployment/web-deployment web=monorepo-polyglot/web:v2.0.0 -n monorepo-polyglot

# Check rollout status
kubectl rollout status deployment/web-deployment -n monorepo-polyglot
```

### Rollbacks

```bash
# Rollback to previous version
kubectl rollout undo deployment/web-deployment -n monorepo-polyglot

# Rollback to specific revision
kubectl rollout undo deployment/web-deployment --to-revision=2 -n monorepo-polyglot
```

## 📋 Maintenance

### Regular Tasks

- **Daily**: Monitor alerts and logs
- **Weekly**: Review resource usage
- **Monthly**: Update dependencies
- **Quarterly**: Security audits

### Backup Strategy

- **Database**: Daily automated backups
- **Secrets**: Encrypted backups
- **Configuration**: Version controlled
- **Logs**: Centralized retention

## 🆘 Support

For production issues:

1. Check monitoring dashboards
2. Review application logs
3. Verify service health
4. Check resource usage
5. Contact team lead if needed

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Security Best Practices](https://kubernetes.io/docs/concepts/security/)
