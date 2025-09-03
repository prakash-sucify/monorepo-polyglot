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
COPY apps/frontend/admin ./apps/frontend/admin
COPY libs ./libs

# Expose port
EXPOSE 3001

# Start the development server
CMD ["pnpm", "dev:admin"]
