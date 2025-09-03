FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY apps/backend/auth-service/package.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY apps/backend/auth-service/src ./src

# Expose port
EXPOSE 3002

# Start the application with ts-node
CMD ["npx", "ts-node", "src/main.ts"]