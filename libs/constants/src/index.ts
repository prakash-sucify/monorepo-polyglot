// Service URLs
export const SERVICE_URLS = {
  AUTH: process.env.AUTH_SERVICE_URL || 'http://localhost:3002',
  PAYMENT: process.env.PAYMENT_SERVICE_URL || 'http://localhost:8080',
  ANALYTICS: process.env.ANALYTICS_SERVICE_URL || 'http://localhost:8081',
  AI: process.env.AI_SERVICE_URL || 'http://localhost:8082',
  PDF: process.env.PDF_SERVICE_URL || 'http://localhost:8083',
} as const;

// Frontend URLs
export const FRONTEND_URLS = {
  WEB: process.env.WEB_APP_URL || 'http://localhost:3000',
  ADMIN: process.env.ADMIN_APP_URL || 'http://localhost:3001',
} as const;

// API Endpoints
export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/auth/login',
    REGISTER: '/auth/register',
    REFRESH: '/auth/refresh',
    LOGOUT: '/auth/logout',
    PROFILE: '/auth/profile',
  },
  PAYMENT: {
    CREATE: '/payment/create',
    GET: '/payment/:id',
    LIST: '/payment/list',
    CANCEL: '/payment/:id/cancel',
  },
  ANALYTICS: {
    TRACK: '/analytics/track',
    EVENTS: '/analytics/events',
    METRICS: '/analytics/metrics',
  },
  AI: {
    CHAT: '/ai/chat',
    COMPLETE: '/ai/complete',
    EMBED: '/ai/embed',
  },
  PDF: {
    GENERATE: '/pdf/generate',
    MERGE: '/pdf/merge',
    SPLIT: '/pdf/split',
    CONVERT: '/pdf/convert',
  },
} as const;

// HTTP Status Codes
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  INTERNAL_SERVER_ERROR: 500,
} as const;

// Environment Types
export const ENVIRONMENTS = {
  DEVELOPMENT: 'development',
  STAGING: 'staging',
  PRODUCTION: 'production',
} as const;

// User Roles
export const USER_ROLES = {
  ADMIN: 'admin',
  USER: 'user',
  MODERATOR: 'moderator',
} as const;

// Event Types
export const EVENT_TYPES = {
  USER_LOGIN: 'user_login',
  USER_LOGOUT: 'user_logout',
  USER_REGISTER: 'user_register',
  PAYMENT_CREATED: 'payment_created',
  PAYMENT_COMPLETED: 'payment_completed',
  PDF_GENERATED: 'pdf_generated',
  AI_REQUEST: 'ai_request',
} as const;

// Currency Codes
export const CURRENCIES = {
  USD: 'USD',
  EUR: 'EUR',
  GBP: 'GBP',
  JPY: 'JPY',
  CAD: 'CAD',
  AUD: 'AUD',
} as const;

// File Types
export const FILE_TYPES = {
  PDF: 'application/pdf',
  IMAGE: 'image/*',
  DOCUMENT: 'application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document',
} as const;

// Pagination
export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 20,
  MAX_PAGE_SIZE: 100,
} as const;

// Cache Keys
export const CACHE_KEYS = {
  USER_PROFILE: 'user_profile',
  PAYMENT_HISTORY: 'payment_history',
  ANALYTICS_METRICS: 'analytics_metrics',
} as const;

// Error Messages
export const ERROR_MESSAGES = {
  INVALID_CREDENTIALS: 'Invalid email or password',
  USER_NOT_FOUND: 'User not found',
  UNAUTHORIZED: 'Unauthorized access',
  FORBIDDEN: 'Access forbidden',
  VALIDATION_ERROR: 'Validation error',
  INTERNAL_ERROR: 'Internal server error',
  SERVICE_UNAVAILABLE: 'Service temporarily unavailable',
} as const;
