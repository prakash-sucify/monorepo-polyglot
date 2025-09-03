#!/bin/bash

# Security Scanning Script
set -e

echo "🔒 Starting Security Scan..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v trivy &> /dev/null; then
        print_error "Trivy is not installed. Please install it first."
        exit 1
    fi
    
    if ! command -v snyk &> /dev/null; then
        print_warning "Snyk is not installed. Some scans will be skipped."
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install Node.js first."
        exit 1
    fi
}

# Run Trivy vulnerability scan
run_trivy_scan() {
    print_status "Running Trivy vulnerability scan..."
    
    # Scan Docker images
    if [ -f "docker-compose.yml" ]; then
        print_status "Scanning Docker images..."
        trivy image --config security/scanning/trivy-config.yaml \
            --format table \
            --output trivy-docker-results.txt \
            $(grep -E '^[[:space:]]*image:' docker-compose.yml | awk '{print $2}' | tr '\n' ' ')
    fi
    
    # Scan filesystem
    print_status "Scanning filesystem for vulnerabilities..."
    trivy fs --config security/scanning/trivy-config.yaml \
        --format table \
        --output trivy-fs-results.txt \
        .
    
    # Scan for secrets
    print_status "Scanning for secrets..."
    trivy fs --scanners secret \
        --config security/scanning/trivy-config.yaml \
        --format table \
        --output trivy-secrets-results.txt \
        .
}

# Run Snyk scan
run_snyk_scan() {
    if command -v snyk &> /dev/null; then
        print_status "Running Snyk scan..."
        
        # Scan Node.js dependencies
        if [ -f "package.json" ]; then
            print_status "Scanning Node.js dependencies..."
            snyk test --severity-threshold=high --json > snyk-results.json || true
        fi
        
        # Scan Docker images
        if [ -f "docker-compose.yml" ]; then
            print_status "Scanning Docker images with Snyk..."
            snyk container test $(grep -E '^[[:space:]]*image:' docker-compose.yml | awk '{print $2}' | head -1) --json > snyk-container-results.json || true
        fi
    else
        print_warning "Snyk not available, skipping Snyk scans"
    fi
}

# Run npm audit
run_npm_audit() {
    print_status "Running npm audit..."
    
    if [ -f "package.json" ]; then
        npm audit --audit-level moderate --json > npm-audit-results.json || true
        npm audit --audit-level moderate > npm-audit-results.txt || true
    fi
}

# Run dependency checks for other languages
run_language_audits() {
    print_status "Running language-specific audits..."
    
    # Go
    if [ -f "apps/backend/payment-service/go.mod" ]; then
        print_status "Checking Go dependencies..."
        cd apps/backend/payment-service
        go list -json -m all > ../../../go-deps.json || true
        cd ../../..
    fi
    
    # Python
    if [ -f "apps/backend/ai-service/pyproject.toml" ]; then
        print_status "Checking Python dependencies..."
        cd apps/backend/ai-service
        uv tree > ../../../python-deps.txt || true
        cd ../../..
    fi
    
    # Rust
    if [ -f "apps/backend/analytics-service/Cargo.toml" ]; then
        print_status "Checking Rust dependencies..."
        cd apps/backend/analytics-service
        cargo audit --json > ../../../rust-audit-results.json || true
        cd ../../..
    fi
    
    # Java
    if [ -f "apps/backend/pdf-service/pom.xml" ]; then
        print_status "Checking Java dependencies..."
        cd apps/backend/pdf-service
        ./mvnw dependency:tree > ../../../java-deps.txt || true
        cd ../../..
    fi
}

# Generate security report
generate_report() {
    print_status "Generating security report..."
    
    cat > security-report.md << EOF
# Security Scan Report

Generated on: $(date)

## Summary

This report contains the results of security scans performed on the monorepo-polyglot project.

## Scans Performed

1. **Trivy Vulnerability Scan**
   - Filesystem scan: \`trivy-fs-results.txt\`
   - Docker images scan: \`trivy-docker-results.txt\`
   - Secrets scan: \`trivy-secrets-results.txt\`

2. **Snyk Scan**
   - Node.js dependencies: \`snyk-results.json\`
   - Docker containers: \`snyk-container-results.json\`

3. **npm Audit**
   - Results: \`npm-audit-results.json\`

4. **Language-specific Audits**
   - Go dependencies: \`go-deps.json\`
   - Python dependencies: \`python-deps.txt\`
   - Rust audit: \`rust-audit-results.json\`
   - Java dependencies: \`java-deps.txt\`

## Recommendations

1. Review all HIGH and CRITICAL vulnerabilities
2. Update dependencies to latest secure versions
3. Remove any exposed secrets from the codebase
4. Implement proper secret management
5. Regular security scans in CI/CD pipeline

## Files Generated

- \`trivy-fs-results.txt\` - Filesystem vulnerability scan
- \`trivy-docker-results.txt\` - Docker image vulnerability scan
- \`trivy-secrets-results.txt\` - Secret detection scan
- \`snyk-results.json\` - Snyk vulnerability scan
- \`snyk-container-results.json\` - Snyk container scan
- \`npm-audit-results.json\` - npm audit results
- \`go-deps.json\` - Go dependencies
- \`python-deps.txt\` - Python dependencies
- \`rust-audit-results.json\` - Rust audit results
- \`java-deps.txt\` - Java dependencies

EOF

    print_status "Security report generated: security-report.md"
}

# Main execution
main() {
    print_status "Starting comprehensive security scan..."
    
    check_dependencies
    run_trivy_scan
    run_snyk_scan
    run_npm_audit
    run_language_audits
    generate_report
    
    print_status "Security scan completed!"
    print_status "Review the generated files and security-report.md for details."
}

# Run main function
main "$@"
