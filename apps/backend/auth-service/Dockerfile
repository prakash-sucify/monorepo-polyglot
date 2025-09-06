FROM node:18-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy package files
COPY apps/backend/auth-service/package.json ./
COPY apps/backend/auth-service/tsconfig.json ./

# Install dependencies
RUN pnpm install

# Copy source code
COPY apps/backend/auth-service/src ./src

# Create dist directory and set permissions
RUN mkdir -p dist && chown -R node:node /app

# Build TypeScript to JavaScript
RUN pnpm run build

# Expose port
EXPOSE 3002

# Start the application with compiled JavaScript
CMD ["pnpm", "start"]