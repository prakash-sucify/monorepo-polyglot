#!/bin/bash

# Secrets Management Utilities
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

# Generate secure random secrets
generate_secrets() {
    print_status "Generating secure secrets..."
    
    # JWT Secret
    JWT_SECRET=$(openssl rand -base64 32)
    echo "JWT_SECRET=$JWT_SECRET" > .env.secrets
    
    # Database Password
    DB_PASSWORD=$(openssl rand -base64 32)
    echo "DB_PASSWORD=$DB_PASSWORD" >> .env.secrets
    
    # API Keys (placeholder - replace with actual keys)
    echo "STRIPE_SECRET_KEY=sk_live_$(openssl rand -hex 24)" >> .env.secrets
    echo "STRIPE_PUBLISHABLE_KEY=pk_live_$(openssl rand -hex 24)" >> .env.secrets
    echo "OPENAI_API_KEY=sk-$(openssl rand -hex 32)" >> .env.secrets
    
    # Email credentials
    echo "SMTP_USER=noreply@yourdomain.com" >> .env.secrets
    echo "SMTP_PASS=$(openssl rand -base64 16)" >> .env.secrets
    
    print_status "Secrets generated in .env.secrets"
    print_warning "Remember to replace placeholder API keys with actual keys!"
}

# Encrypt secrets for Kubernetes
encrypt_secrets() {
    print_status "Encrypting secrets for Kubernetes..."
    
    if [ ! -f ".env.secrets" ]; then
        print_error ".env.secrets file not found. Run generate_secrets first."
        exit 1
    fi
    
    # Create Kubernetes secret
    kubectl create secret generic monorepo-polyglot-secrets \
        --from-env-file=.env.secrets \
        --namespace=monorepo-polyglot \
        --dry-run=client -o yaml > k8s/base/secrets.yaml
    
    print_status "Kubernetes secret created: k8s/base/secrets.yaml"
}

# Seal secrets using kubeseal
seal_secrets() {
    print_status "Sealing secrets using kubeseal..."
    
    if ! command -v kubeseal &> /dev/null; then
        print_error "kubeseal is not installed. Please install it first."
        exit 1
    fi
    
    if [ ! -f "k8s/base/secrets.yaml" ]; then
        print_error "k8s/base/secrets.yaml not found. Run encrypt_secrets first."
        exit 1
    fi
    
    # Seal the secret
    kubeseal --format=yaml < k8s/base/secrets.yaml > security/secrets/sealed-secrets.yaml
    
    print_status "Sealed secret created: security/secrets/sealed-secrets.yaml"
}

# Rotate secrets
rotate_secrets() {
    print_status "Rotating secrets..."
    
    # Generate new secrets
    generate_secrets
    
    # Encrypt new secrets
    encrypt_secrets
    
    # Apply new secrets to cluster
    kubectl apply -f k8s/base/secrets.yaml
    
    # Restart deployments to pick up new secrets
    kubectl rollout restart deployment/auth-deployment -n monorepo-polyglot
    kubectl rollout restart deployment/postgres-deployment -n monorepo-polyglot
    
    print_status "Secrets rotated and deployments restarted"
}

# Backup secrets
backup_secrets() {
    print_status "Backing up secrets..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="security/secrets/backups"
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup Kubernetes secrets
    kubectl get secret monorepo-polyglot-secrets -n monorepo-polyglot -o yaml > "$BACKUP_DIR/secrets_$TIMESTAMP.yaml"
    
    # Backup sealed secrets
    if [ -f "security/secrets/sealed-secrets.yaml" ]; then
        cp security/secrets/sealed-secrets.yaml "$BACKUP_DIR/sealed-secrets_$TIMESTAMP.yaml"
    fi
    
    # Create encrypted archive
    tar -czf "$BACKUP_DIR/secrets_backup_$TIMESTAMP.tar.gz" "$BACKUP_DIR"/*_$TIMESTAMP.yaml
    gpg --symmetric --cipher-algo AES256 "$BACKUP_DIR/secrets_backup_$TIMESTAMP.tar.gz"
    
    # Clean up unencrypted files
    rm "$BACKUP_DIR"/*_$TIMESTAMP.yaml
    rm "$BACKUP_DIR/secrets_backup_$TIMESTAMP.tar.gz"
    
    print_status "Secrets backed up to: $BACKUP_DIR/secrets_backup_$TIMESTAMP.tar.gz.gpg"
}

# Restore secrets from backup
restore_secrets() {
    if [ -z "$1" ]; then
        print_error "Please provide backup file path"
        echo "Usage: $0 restore <backup-file>"
        exit 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        print_error "Backup file not found: $BACKUP_FILE"
        exit 1
    fi
    
    print_status "Restoring secrets from: $BACKUP_FILE"
    
    # Decrypt backup
    gpg --decrypt "$BACKUP_FILE" > temp_backup.tar.gz
    
    # Extract backup
    tar -xzf temp_backup.tar.gz
    
    # Apply secrets to cluster
    kubectl apply -f security/secrets/backups/secrets_*.yaml
    
    # Clean up
    rm temp_backup.tar.gz
    rm -rf security/secrets/backups/
    
    print_status "Secrets restored successfully"
}

# Validate secrets
validate_secrets() {
    print_status "Validating secrets..."
    
    # Check if secrets exist in cluster
    if kubectl get secret monorepo-polyglot-secrets -n monorepo-polyglot &> /dev/null; then
        print_status "✅ Secrets exist in cluster"
    else
        print_error "❌ Secrets not found in cluster"
        return 1
    fi
    
    # Check if secrets are properly formatted
    if kubectl get secret monorepo-polyglot-secrets -n monorepo-polyglot -o jsonpath='{.data}' | jq . &> /dev/null; then
        print_status "✅ Secrets are properly formatted"
    else
        print_error "❌ Secrets are not properly formatted"
        return 1
    fi
    
    # Check if required keys exist
    REQUIRED_KEYS=("POSTGRES_USER" "POSTGRES_PASSWORD" "JWT_SECRET" "STRIPE_SECRET_KEY" "OPENAI_API_KEY")
    
    for key in "${REQUIRED_KEYS[@]}"; do
        if kubectl get secret monorepo-polyglot-secrets -n monorepo-polyglot -o jsonpath="{.data.$key}" &> /dev/null; then
            print_status "✅ Key $key exists"
        else
            print_error "❌ Key $key missing"
        fi
    done
}

# Show usage
show_usage() {
    echo "Secrets Management Utilities"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  generate     Generate new secure secrets"
    echo "  encrypt      Encrypt secrets for Kubernetes"
    echo "  seal         Seal secrets using kubeseal"
    echo "  rotate       Rotate all secrets"
    echo "  backup       Backup current secrets"
    echo "  restore      Restore secrets from backup"
    echo "  validate     Validate secrets in cluster"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 generate"
    echo "  $0 encrypt"
    echo "  $0 rotate"
    echo "  $0 backup"
    echo "  $0 restore security/secrets/backups/secrets_backup_20231201_120000.tar.gz.gpg"
}

# Main execution
main() {
    case "${1:-help}" in
        generate)
            generate_secrets
            ;;
        encrypt)
            encrypt_secrets
            ;;
        seal)
            seal_secrets
            ;;
        rotate)
            rotate_secrets
            ;;
        backup)
            backup_secrets
            ;;
        restore)
            restore_secrets "$2"
            ;;
        validate)
            validate_secrets
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
