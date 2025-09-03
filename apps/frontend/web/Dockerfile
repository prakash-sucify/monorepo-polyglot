FROM node:18-alpine

WORKDIR /app

# Copy root package files
COPY package*.json ./
COPY pnpm-lock.yaml ./
COPY nx.json ./
COPY tsconfig.base.json ./

# Install pnpm and dependencies
RUN npm install -g pnpm
RUN pnpm install

# Copy source code
COPY apps/frontend/web ./apps/frontend/web
COPY libs ./libs

# Expose port
EXPOSE 3000

# Start the development server
CMD ["pnpm", "dev:web"]