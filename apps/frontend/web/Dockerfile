# Multi-stage build for optimized web app
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

# Copy only web app and shared libraries
COPY apps/frontend/web ./apps/frontend/web
COPY libs ./libs

# Build only the web application using individual build command
RUN pnpm build:web

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

# Install pnpm for production
RUN npm install -g pnpm

# Copy only the built application and necessary files
COPY --from=builder /app/dist/apps/frontend/web ./dist/apps/frontend/web
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Expose port
EXPOSE 3000

# Start the production server
WORKDIR /app/dist/apps/frontend/web
CMD ["npx", "next", "start", "-p", "3000"]