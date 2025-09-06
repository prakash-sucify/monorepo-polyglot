# Multi-stage build for optimized admin app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy root package files
COPY package*.json ./
COPY pnpm-lock.yaml ./
COPY nx.json ./
COPY tsconfig.base.json ./

# Install pnpm and dependencies
RUN npm install -g pnpm
RUN pnpm install

# Copy only admin app and shared libraries
COPY apps/frontend/admin ./apps/frontend/admin
COPY libs ./libs

# Build only the admin application using individual build command
RUN pnpm build:admin

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

# Install pnpm for production
RUN npm install -g pnpm

# Copy only the built application and necessary files
COPY --from=builder /app/dist/apps/frontend/admin ./dist/apps/frontend/admin
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Expose port
EXPOSE 3001

# Start the production server
WORKDIR /app/dist/apps/frontend/admin
CMD ["npx", "next", "start", "-p", "3001"]