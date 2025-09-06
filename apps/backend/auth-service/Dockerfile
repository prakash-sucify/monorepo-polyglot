# Multi-stage build for optimized auth service
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

# Copy only auth service and shared libraries
COPY apps/backend/auth-service ./apps/backend/auth-service
COPY libs ./libs

# Build only the auth service using individual build command
RUN pnpm build:auth

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

# Install pnpm for production
RUN npm install -g pnpm

# Copy only the built application and necessary files
COPY --from=builder /app/dist/auth-service ./dist/auth-service
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Expose port
EXPOSE 3002

# Start the production server
WORKDIR /app/dist/auth-service
CMD ["node", "main.js"]