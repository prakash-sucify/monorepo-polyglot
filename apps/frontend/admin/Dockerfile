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

# Build the admin application
RUN pnpm build:frontend

# Expose port
EXPOSE 3001

# Start the production server
WORKDIR /app/dist/apps/frontend/admin
CMD ["npx", "next", "start", "-p", "3001"]
