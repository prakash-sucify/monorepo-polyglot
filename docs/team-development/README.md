# 🚀 Team-Specific Development Guide

This guide shows how teams can work with only their relevant code locally using sparse checkouts.

## 🎯 **Problem Solved**

**Before**: Teams had to clone the entire 500MB+ monorepo
**After**: Teams clone only what they need (20-50MB)

## 📱 **Frontend Team Setup**

### **Clone Frontend Workspace**
```bash
# Clone only frontend-related code
./tools/scripts/team-clone.sh frontend

# Or manually
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-org/monorepo-polyglot.git monorepo-frontend
cd monorepo-frontend
git sparse-checkout init --cone
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
  tsconfig.base.json
```

### **Frontend Development**
```bash
# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start frontend development
pnpm team:frontend dev

# Or start individual apps
npx nx serve web
npx nx serve admin
```

### **Frontend Testing**
```bash
# Test frontend projects
pnpm team:frontend test

# Test specific app
npx nx test web
npx nx test admin

# E2E tests
npx nx e2e web-e2e
npx nx e2e admin-e2e
```

## 🔧 **Backend Team Setup**

### **Clone Backend Workspace**
```bash
# Clone only backend-related code
./tools/scripts/team-clone.sh backend

# Or manually
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-org/monorepo-polyglot.git monorepo-backend
cd monorepo-backend
git sparse-checkout init --cone
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
  tsconfig.base.json
```

### **Backend Development**
```bash
# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start backend development
pnpm team:backend dev

# Or start individual services
npx nx serve auth-service
npx nx serve payment-service
npx nx serve pdf-service
```

### **Backend Testing**
```bash
# Test backend projects
pnpm team:backend test

# Test specific service
npx nx test auth-service
npx nx test payment-service

# E2E tests
npx nx e2e auth-service-e2e
```

## 📊 **Data Team Setup**

### **Clone Data Workspace**
```bash
# Clone only data-related code
./tools/scripts/team-clone.sh data

# Or manually
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-org/monorepo-polyglot.git monorepo-data
cd monorepo-data
git sparse-checkout init --cone
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
  tsconfig.base.json
```

### **Data Development**
```bash
# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start data development
pnpm team:data dev

# Or start analytics service
npx nx serve analytics-service
```

## 🤖 **AI Team Setup**

### **Clone AI Workspace**
```bash
# Clone only AI-related code
./tools/scripts/team-clone.sh ai

# Or manually
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-org/monorepo-polyglot.git monorepo-ai
cd monorepo-ai
git sparse-checkout init --cone
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
  tsconfig.base.json
```

### **AI Development**
```bash
# Install dependencies
pnpm install

# Build shared libraries
pnpm build:libs

# Start AI development
pnpm team:ai dev

# Or start AI service
npx nx serve ai-service
```

## 🛠️ **Platform Team Setup**

### **Clone Platform Workspace**
```bash
# Clone only platform-related code
./tools/scripts/team-clone.sh platform

# Or manually
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-org/monorepo-polyglot.git monorepo-platform
cd monorepo-platform
git sparse-checkout init --cone
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
  tsconfig.base.json
```

### **Platform Development**
```bash
# Install dependencies
pnpm install

# Build all shared libraries
pnpm build:libs

# Test all shared libraries
pnpm test:libs

# Lint all shared libraries
pnpm lint:libs
```

## 🐳 **Team-Specific Docker**

### **Frontend Docker**
```bash
# Copy team-specific docker-compose
cp tools/docker/team-docker-compose.yml docker-compose.yml

# Start frontend services
docker compose --profile frontend --profile shared up -d

# Or start specific services
docker compose up web admin redis -d
```

### **Backend Docker**
```bash
# Start backend services
docker compose --profile backend --profile shared up -d

# Or start specific services
docker compose up auth-service payment-service postgres redis -d
```

### **Data Docker**
```bash
# Start data services
docker compose --profile data --profile shared up -d

# Or start specific services
docker compose up analytics-service postgres redis -d
```

## 📊 **Repository Size Comparison**

| Team | Full Monorepo | Team Workspace | Reduction |
|------|---------------|----------------|-----------|
| **Frontend** | ~500MB | ~50MB | 90% |
| **Backend** | ~500MB | ~80MB | 84% |
| **Data** | ~500MB | ~30MB | 94% |
| **AI** | ~500MB | ~25MB | 95% |
| **Platform** | ~500MB | ~100MB | 80% |

## 🚀 **Team Workflows**

### **Daily Development**
```bash
# 1. Pull latest changes
git pull origin main

# 2. Update sparse checkout if needed
git sparse-checkout reapply

# 3. Install dependencies
pnpm install

# 4. Build shared libraries
pnpm build:libs

# 5. Start development
pnpm team:frontend dev  # or backend, data, ai
```

### **Adding New Files**
```bash
# If you need to access other parts temporarily
git sparse-checkout add apps/other-service/

# Remove when done
git sparse-checkout remove apps/other-service/

# Reset to team defaults
git sparse-checkout reapply
```

### **Testing Changes**
```bash
# Test only your team's projects
pnpm team:frontend test

# Test specific project
npx nx test web

# Test with coverage
npx nx test web --coverage
```

## 🔄 **Updating Workspace**

### **Regular Updates**
```bash
# Pull latest changes
git pull origin main

# Update dependencies
pnpm install

# Rebuild shared libraries
pnpm build:libs
```

### **Adding New Dependencies**
```bash
# Add to root package.json (requires platform team approval)
pnpm add new-package

# Or add to specific project
npx nx g @nx/js:library new-lib
```

## 🆘 **Troubleshooting**

### **Missing Files**
```bash
# Check what's included
git sparse-checkout list

# Add missing files
git sparse-checkout add path/to/missing/file

# Reset to defaults
git sparse-checkout reapply
```

### **Build Failures**
```bash
# Check if shared libraries are built
pnpm build:libs

# Check dependencies
pnpm install

# Check NX cache
npx nx reset
```

### **Import Errors**
```bash
# Check if you're importing from outside your team's scope
npx nx lint

# Check team boundaries
pnpm boundaries:check
```

## 🎯 **Best Practices**

### **1. Keep Workspace Focused**
- Only add files you actually need
- Remove files when no longer needed
- Use `git sparse-checkout reapply` regularly

### **2. Coordinate with Other Teams**
- Use shared libraries for common functionality
- Document API changes
- Coordinate releases

### **3. Regular Maintenance**
- Update dependencies regularly
- Clean up unused files
- Keep workspace size minimal

## 🎉 **Benefits**

### **1. Performance**
- ✅ **90% smaller** repository size
- ✅ **Faster clones** (30 seconds vs 5 minutes)
- ✅ **Faster builds** (only build what you need)
- ✅ **Less disk space** usage

### **2. Developer Experience**
- ✅ **Focused workspace** (only relevant code)
- ✅ **Faster IDE** performance
- ✅ **Less confusion** about what to work on
- ✅ **Clear boundaries** between teams

### **3. Team Productivity**
- ✅ **Independent development** workflows
- ✅ **Faster onboarding** for new team members
- ✅ **Reduced conflicts** between teams
- ✅ **Better focus** on team-specific tasks

## 🚀 **Quick Start Commands**

```bash
# Frontend team
./tools/scripts/team-clone.sh frontend
cd monorepo-polyglot-frontend
./team-setup.sh

# Backend team
./tools/scripts/team-clone.sh backend
cd monorepo-polyglot-backend
./team-setup.sh

# Data team
./tools/scripts/team-clone.sh data
cd monorepo-polyglot-data
./team-setup.sh

# AI team
./tools/scripts/team-clone.sh ai
cd monorepo-polyglot-ai
./team-setup.sh

# Platform team
./tools/scripts/team-clone.sh platform
cd monorepo-polyglot-platform
./team-setup.sh
```

**Your teams can now work efficiently with only the code they need!** 🚀
