import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';

export interface ServiceConfig {
  baseURL: string;
  timeout?: number;
  headers?: Record<string, string>;
}

export class ApiClient {
  private client: AxiosInstance;

  constructor(config: ServiceConfig) {
    this.client = axios.create({
      baseURL: config.baseURL,
      timeout: config.timeout || 10000,
      headers: {
        'Content-Type': 'application/json',
        ...config.headers,
      },
    });

    // Add request interceptor for auth
    this.client.interceptors.request.use(
      (config) => {
        const token = localStorage.getItem('auth_token');
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Add response interceptor for error handling
    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          localStorage.removeItem('auth_token');
          window.location.href = '/login';
        }
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.get<T>(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.post<T>(url, data, config);
    return response.data;
  }

  async put<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.put<T>(url, data, config);
    return response.data;
  }

  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.delete<T>(url, config);
    return response.data;
  }
}

// Service-specific clients
export const authClient = new ApiClient({
  baseURL: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3002',
});

export const paymentClient = new ApiClient({
  baseURL: process.env.NEXT_PUBLIC_PAYMENT_SERVICE_URL || 'http://localhost:8080',
});

export const analyticsClient = new ApiClient({
  baseURL: process.env.NEXT_PUBLIC_ANALYTICS_SERVICE_URL || 'http://localhost:8081',
});

export const aiClient = new ApiClient({
  baseURL: process.env.NEXT_PUBLIC_AI_SERVICE_URL || 'http://localhost:8082',
});

export const pdfClient = new ApiClient({
  baseURL: process.env.NEXT_PUBLIC_PDF_SERVICE_URL || 'http://localhost:8083',
});
