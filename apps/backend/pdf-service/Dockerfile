# Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests -X

# Check if JAR was created
RUN ls -la target/
RUN find target/ -name "*.jar" -type f

# Runtime stage
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built jar
COPY --from=builder /app/target/pdf-service-1.0.0.jar ./app.jar

# Expose port
EXPOSE 8083

# Run the application
CMD ["java", "-jar", "app.jar"]
