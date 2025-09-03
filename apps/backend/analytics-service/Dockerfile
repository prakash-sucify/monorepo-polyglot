# Build stage
FROM rust:1.85-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache musl-dev

# Copy Cargo files
COPY Cargo.toml ./

# Copy source code
COPY src ./src

# Generate Cargo.lock and build the application
RUN cargo generate-lockfile && cargo build --release

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/target/release/analytics-service .

# Expose port
EXPOSE 8081

# Run the application
CMD ["./analytics-service"]
