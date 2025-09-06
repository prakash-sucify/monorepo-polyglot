# Multi-stage build for optimized AI service
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY pyproject.toml ./

# Install uv
RUN pip install uv

# Install dependencies
RUN uv pip install --system -e .

# Copy source code
COPY . .

# Build the application using individual build command
RUN uv build

# Runtime stage
FROM python:3.11-slim AS runner

WORKDIR /app

# Install uv
RUN pip install uv

# Copy the built application
COPY --from=builder /app/dist ./dist

# Expose port
EXPOSE 8082

# Run the application
CMD ["uv", "run", "python", "src/ai_service_python/main.py"]