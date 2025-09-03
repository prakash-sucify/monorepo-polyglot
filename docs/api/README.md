# API Documentation

This document provides comprehensive API documentation for all services in the polyglot monorepo.

## 🔗 Service Endpoints

### Base URLs

| Environment | Web App | Admin Panel | Auth Service | Payment Service | Analytics Service | AI Service | PDF Service |
|-------------|---------|-------------|--------------|-----------------|-------------------|------------|-------------|
| Development | http://localhost:3000 | http://localhost:3001 | http://localhost:3002 | http://localhost:8080 | http://localhost:8081 | http://localhost:8082 | http://localhost:8083 |
| Staging | https://staging-web.yourdomain.com | https://staging-admin.yourdomain.com | https://staging-auth.yourdomain.com | https://staging-payment.yourdomain.com | https://staging-analytics.yourdomain.com | https://staging-ai.yourdomain.com | https://staging-pdf.yourdomain.com |
| Production | https://yourdomain.com | https://admin.yourdomain.com | https://auth.yourdomain.com | https://payment.yourdomain.com | https://analytics.yourdomain.com | https://ai.yourdomain.com | https://pdf.yourdomain.com |

## 🔐 Auth Service API

**Base URL**: `http://localhost:3002`

### Authentication Endpoints

#### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

#### POST /auth/login
Authenticate a user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe"
  },
  "tokens": {
    "accessToken": "jwt_access_token",
    "refreshToken": "jwt_refresh_token"
  }
}
```

#### POST /auth/refresh
Refresh access token.

**Request Body:**
```json
{
  "refreshToken": "jwt_refresh_token"
}
```

**Response:**
```json
{
  "success": true,
  "accessToken": "new_jwt_access_token"
}
```

#### GET /auth/profile
Get user profile (requires authentication).

**Headers:**
```
Authorization: Bearer jwt_access_token
```

**Response:**
```json
{
  "success": true,
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

#### POST /auth/logout
Logout user (requires authentication).

**Headers:**
```
Authorization: Bearer jwt_access_token
```

**Response:**
```json
{
  "success": true,
  "message": "Logout successful"
}
```

## 💳 Payment Service API

**Base URL**: `http://localhost:8080`

### Payment Endpoints

#### POST /payment/create
Create a new payment.

**Request Body:**
```json
{
  "amount": 1000,
  "currency": "USD",
  "description": "Payment for services",
  "customerId": "customer_id"
}
```

**Response:**
```json
{
  "success": true,
  "payment": {
    "id": "payment_id",
    "amount": 1000,
    "currency": "USD",
    "status": "pending",
    "stripePaymentIntentId": "pi_stripe_id",
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

#### GET /payment/:id
Get payment details.

**Response:**
```json
{
  "success": true,
  "payment": {
    "id": "payment_id",
    "amount": 1000,
    "currency": "USD",
    "status": "completed",
    "stripePaymentIntentId": "pi_stripe_id",
    "createdAt": "2024-01-01T00:00:00Z",
    "completedAt": "2024-01-01T00:01:00Z"
  }
}
```

#### GET /payment/list
List payments with pagination.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)
- `status` (optional): Filter by status

**Response:**
```json
{
  "success": true,
  "payments": [
    {
      "id": "payment_id",
      "amount": 1000,
      "currency": "USD",
      "status": "completed",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1,
    "totalPages": 1
  }
}
```

#### POST /payment/:id/cancel
Cancel a payment.

**Response:**
```json
{
  "success": true,
  "message": "Payment cancelled successfully"
}
```

#### GET /health
Health check endpoint.

**Response:**
```json
{
  "service": "payment-service",
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## 📊 Analytics Service API

**Base URL**: `http://localhost:8081`

### Analytics Endpoints

#### POST /analytics/track
Track an event.

**Request Body:**
```json
{
  "eventType": "user_login",
  "userId": "user_id",
  "properties": {
    "source": "web",
    "device": "desktop"
  },
  "timestamp": "2024-01-01T00:00:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Event tracked successfully",
  "eventId": "event_id"
}
```

#### GET /analytics/events
Get events with filtering.

**Query Parameters:**
- `eventType` (optional): Filter by event type
- `userId` (optional): Filter by user ID
- `startDate` (optional): Start date (ISO format)
- `endDate` (optional): End date (ISO format)
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:**
```json
{
  "success": true,
  "events": [
    {
      "id": "event_id",
      "eventType": "user_login",
      "userId": "user_id",
      "properties": {
        "source": "web",
        "device": "desktop"
      },
      "timestamp": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1,
    "totalPages": 1
  }
}
```

#### GET /analytics/metrics
Get analytics metrics.

**Query Parameters:**
- `startDate` (optional): Start date (ISO format)
- `endDate` (optional): End date (ISO format)
- `groupBy` (optional): Group by field (hour, day, week, month)

**Response:**
```json
{
  "success": true,
  "metrics": {
    "totalEvents": 1000,
    "uniqueUsers": 100,
    "eventsByType": {
      "user_login": 500,
      "user_logout": 300,
      "payment_created": 200
    },
    "eventsOverTime": [
      {
        "date": "2024-01-01",
        "count": 100
      }
    ]
  }
}
```

#### GET /health
Health check endpoint.

**Response:**
```json
{
  "service": "analytics-service",
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## 🤖 AI Service API

**Base URL**: `http://localhost:8082`

### AI Endpoints

#### POST /ai/chat
Chat with AI assistant.

**Request Body:**
```json
{
  "message": "Hello, how can you help me?",
  "conversationId": "conversation_id",
  "model": "gpt-3.5-turbo"
}
```

**Response:**
```json
{
  "success": true,
  "response": "Hello! I'm here to help you with various tasks...",
  "conversationId": "conversation_id",
  "model": "gpt-3.5-turbo",
  "usage": {
    "promptTokens": 10,
    "completionTokens": 20,
    "totalTokens": 30
  }
}
```

#### POST /ai/complete
Complete text using AI.

**Request Body:**
```json
{
  "prompt": "The future of technology is",
  "maxTokens": 100,
  "temperature": 0.7
}
```

**Response:**
```json
{
  "success": true,
  "completion": "The future of technology is bright and full of possibilities...",
  "usage": {
    "promptTokens": 5,
    "completionTokens": 20,
    "totalTokens": 25
  }
}
```

#### POST /ai/embed
Generate text embeddings.

**Request Body:**
```json
{
  "text": "This is a sample text for embedding",
  "model": "text-embedding-ada-002"
}
```

**Response:**
```json
{
  "success": true,
  "embedding": [0.1, 0.2, 0.3, ...],
  "model": "text-embedding-ada-002",
  "usage": {
    "promptTokens": 10,
    "totalTokens": 10
  }
}
```

#### GET /health
Health check endpoint.

**Response:**
```json
{
  "status": "healthy",
  "service": "ai-service",
  "version": "1.0.0",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## 📄 PDF Service API

**Base URL**: `http://localhost:8083`

### PDF Endpoints

#### POST /pdf/generate
Generate a PDF from HTML or text.

**Request Body:**
```json
{
  "content": "<html><body><h1>Hello World</h1></body></html>",
  "type": "html",
  "options": {
    "format": "A4",
    "orientation": "portrait"
  }
}
```

**Response:**
```json
{
  "success": true,
  "pdfId": "pdf_id",
  "downloadUrl": "/pdf/download/pdf_id",
  "size": 1024
}
```

#### POST /pdf/merge
Merge multiple PDFs.

**Request Body:**
```json
{
  "pdfIds": ["pdf_id_1", "pdf_id_2"],
  "options": {
    "order": "sequential"
  }
}
```

**Response:**
```json
{
  "success": true,
  "mergedPdfId": "merged_pdf_id",
  "downloadUrl": "/pdf/download/merged_pdf_id"
}
```

#### POST /pdf/split
Split a PDF into multiple pages.

**Request Body:**
```json
{
  "pdfId": "pdf_id",
  "pages": [1, 2, 3]
}
```

**Response:**
```json
{
  "success": true,
  "splitPdfIds": ["split_pdf_1", "split_pdf_2", "split_pdf_3"],
  "downloadUrls": [
    "/pdf/download/split_pdf_1",
    "/pdf/download/split_pdf_2",
    "/pdf/download/split_pdf_3"
  ]
}
```

#### POST /pdf/convert
Convert document to PDF.

**Request Body:**
```multipart/form-data
file: document.docx
```

**Response:**
```json
{
  "success": true,
  "pdfId": "converted_pdf_id",
  "downloadUrl": "/pdf/download/converted_pdf_id"
}
```

#### GET /pdf/download/:id
Download a PDF file.

**Response:**
```
Content-Type: application/pdf
Content-Disposition: attachment; filename="document.pdf"

[PDF binary data]
```

#### GET /health
Health check endpoint.

**Response:**
```json
{
  "timestamp": "2024-01-01T00:00:00Z",
  "status": 200,
  "service": "pdf-service"
}
```

## 🔧 Common Response Formats

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation completed successfully"
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": { ... }
  }
}
```

### Pagination Response
```json
{
  "success": true,
  "data": [ ... ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

## 🔒 Authentication

Most endpoints require authentication using JWT tokens. Include the token in the Authorization header:

```
Authorization: Bearer your_jwt_token_here
```

## 📝 Error Codes

| Code | Description |
|------|-------------|
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 422 | Unprocessable Entity - Validation error |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server error |
| 503 | Service Unavailable - Service temporarily unavailable |

## 🧪 Testing

### Health Check
All services provide a health check endpoint at `/health` that returns the service status.

### Postman Collection
A Postman collection is available in `docs/api/postman/` with all API endpoints pre-configured.

### API Testing Scripts
Use the health check script to verify all services are running:

```bash
./tools/scripts/health-check.sh
```

## 📚 Additional Resources

- [Authentication Guide](authentication.md)
- [Rate Limiting](rate-limiting.md)
- [Error Handling](error-handling.md)
- [Webhooks](webhooks.md)
