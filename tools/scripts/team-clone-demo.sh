#!/bin/bash

# Demo script for team-specific sparse checkout
# This works with the current local repository

set -e

TEAM=${1:-""}

print_usage() {
    echo "Usage: $0 <team>"
    echo ""
    echo "Teams:"
    echo "  frontend  - Create frontend workspace"
    echo "  backend   - Create backend workspace"
    echo "  data      - Create data workspace"
    echo "  ai        - Create AI workspace"
    echo "  platform  - Create platform workspace"
    echo ""
    echo "Examples:"
    echo "  $0 frontend"
    echo "  $0 backend"
}

if [ -z "$TEAM" ]; then
    print_usage
    exit 1
fi

# Create team-specific directory
TEAM_DIR="monorepo-polyglot-${TEAM}"
echo "🏗️  Creating $TEAM team workspace..."

# Copy current repository
cp -r . $TEAM_DIR
cd $TEAM_DIR

# Initialize sparse checkout
git sparse-checkout init --cone

case $TEAM in
    "frontend")
        echo "📱 Setting up Frontend Team workspace..."
        git sparse-checkout set \
            apps/frontend/ \
            libs/ui-components/ \
            libs/api-client/ \
            libs/validation/ \
            libs/constants/ \
            libs/utils/ \
            package.json \
            pnpm-lock.yaml \
            nx.json \
            tsconfig.base.json \
            .eslintrc.json \
            jest.config.ts \
            jest.preset.js
        ;;
    "backend")
        echo "🔧 Setting up Backend Team workspace..."
        git sparse-checkout set \
            apps/backend/ \
            libs/api-client/ \
            libs/validation/ \
            libs/constants/ \
            libs/utils/ \
            libs/resilience/ \
            package.json \
            pnpm-lock.yaml \
            nx.json \
            tsconfig.base.json \
            .eslintrc.json \
            jest.config.ts \
            jest.preset.js
        ;;
    "data")
        echo "📊 Setting up Data Team workspace..."
        git sparse-checkout set \
            apps/backend/analytics-service/ \
            libs/api-client/ \
            libs/validation/ \
            libs/constants/ \
            libs/utils/ \
            libs/resilience/ \
            package.json \
            pnpm-lock.yaml \
            nx.json \
            tsconfig.base.json \
            .eslintrc.json \
            jest.config.ts \
            jest.preset.js
        ;;
    "ai")
        echo "🤖 Setting up AI Team workspace..."
        git sparse-checkout set \
            apps/backend/ai-service/ \
            libs/api-client/ \
            libs/validation/ \
            libs/constants/ \
            libs/utils/ \
            libs/resilience/ \
            package.json \
            pnpm-lock.yaml \
            nx.json \
            tsconfig.base.json \
            .eslintrc.json \
            jest.config.ts \
            jest.preset.js
        ;;
    "platform")
        echo "🛠️  Setting up Platform Team workspace..."
        git sparse-checkout set \
            libs/ \
            tools/ \
            k8s/ \
            monitoring/ \
            security/ \
            docs/ \
            package.json \
            pnpm-lock.yaml \
            nx.json \
            tsconfig.base.json \
            .eslintrc.json \
            jest.config.ts \
            jest.preset.js
        ;;
    *)
        echo "❌ Unknown team: $TEAM"
        print_usage
        exit 1
        ;;
esac

# Create team-specific scripts
echo "📝 Creating team-specific scripts..."
cat > team-setup.sh << 'EOF'
#!/bin/bash
# Team-specific setup script

echo "🚀 Setting up development environment..."

# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start development servers
case "$TEAM" in
    "frontend")
        echo "📱 Starting frontend development servers..."
        pnpm team:frontend dev
        ;;
    "backend")
        echo "🔧 Starting backend development servers..."
        pnpm team:backend dev
        ;;
    "data")
        echo "📊 Starting data development servers..."
        pnpm team:data dev
        ;;
    "ai")
        echo "🤖 Starting AI development servers..."
        pnpm team:ai dev
        ;;
    "platform")
        echo "🛠️  Platform team doesn't have dev servers"
        ;;
esac
EOF

chmod +x team-setup.sh

# Create team-specific README
cat > TEAM-README.md << EOF
# 🏗️ $TEAM Team Workspace

This is a sparse checkout of the monorepo containing only the projects relevant to the $TEAM team.

## 📁 What's Included

$(git sparse-checkout list | sed 's/^/- /')

## 🚀 Quick Start

\`\`\`bash
# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start development
./team-setup.sh
\`\`\`

## 🛠️ Team Commands

\`\`\`bash
# Build team projects
pnpm team:$TEAM build

# Test team projects
pnpm team:$TEAM test

# Lint team projects
pnpm team:$TEAM lint

# Start development servers
pnpm team:$TEAM dev
\`\`\`

## 📊 Repository Size

- **Full monorepo**: ~500MB
- **$TEAM team workspace**: ~$(du -sh . | cut -f1)

## 🔄 Updating

\`\`\`bash
# Pull latest changes
git pull origin main

# Update sparse checkout if needed
git sparse-checkout reapply
\`\`\`

## 🆘 Troubleshooting

If you need to access other parts of the monorepo:

\`\`\`bash
# Temporarily add more files
git sparse-checkout add apps/other-service/

# Remove files you don't need
git sparse-checkout remove apps/other-service/

# Reset to team defaults
git sparse-checkout reapply
\`\`\`
EOF

echo "✅ $TEAM team workspace created successfully!"
echo "📁 Location: $(pwd)"
echo "📊 Size: $(du -sh . | cut -f1)"
echo ""
echo "🚀 Next steps:"
echo "   cd $TEAM_DIR"
echo "   ./team-setup.sh"
echo ""
echo "📖 Read TEAM-README.md for more information"
