FROM node:18-alpine

WORKDIR /app

# Copy package files from root
COPY package.json pnpm-lock.yaml ./
COPY nx.json ./
COPY tsconfig.base.json ./

# Install pnpm and dependencies
RUN npm install -g pnpm
RUN pnpm install

# Copy source code
COPY apps/backend/auth-service/ ./apps/backend/auth-service/
COPY libs ./libs

# Build the application
RUN npx nx build auth-service

# Expose port
EXPOSE 3002

# Start the application
CMD ["node", "dist/auth-service/main.js"]