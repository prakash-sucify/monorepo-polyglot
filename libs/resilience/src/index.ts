import { CircuitBreaker, Retry, Timeout, Bulkhead } from 'resilience4js';

export interface ResilienceConfig {
  circuitBreaker?: {
    failureRateThreshold?: number;
    waitDurationInOpenState?: number;
    slidingWindowSize?: number;
    minimumNumberOfCalls?: number;
  };
  retry?: {
    maxAttempts?: number;
    waitDuration?: number;
    retryExceptions?: string[];
  };
  timeout?: {
    duration?: number;
  };
  bulkhead?: {
    maxConcurrentCalls?: number;
    maxWaitDuration?: number;
  };
}

export class ResilienceManager {
  private circuitBreakers: Map<string, CircuitBreaker> = new Map();
  private retries: Map<string, Retry> = new Map();
  private timeouts: Map<string, Timeout> = new Map();
  private bulkheads: Map<string, Bulkhead> = new Map();

  createCircuitBreaker(name: string, config: ResilienceConfig['circuitBreaker'] = {}) {
    const circuitBreaker = new CircuitBreaker({
      failureRateThreshold: config.failureRateThreshold || 50,
      waitDurationInOpenState: config.waitDurationInOpenState || 60000,
      slidingWindowSize: config.slidingWindowSize || 10,
      minimumNumberOfCalls: config.minimumNumberOfCalls || 5,
    });
    
    this.circuitBreakers.set(name, circuitBreaker);
    return circuitBreaker;
  }

  createRetry(name: string, config: ResilienceConfig['retry'] = {}) {
    const retry = new Retry({
      maxAttempts: config.maxAttempts || 3,
      waitDuration: config.waitDuration || 1000,
      retryExceptions: config.retryExceptions || ['Error'],
    });
    
    this.retries.set(name, retry);
    return retry;
  }

  createTimeout(name: string, config: ResilienceConfig['timeout'] = {}) {
    const timeout = new Timeout({
      duration: config.duration || 5000,
    });
    
    this.timeouts.set(name, timeout);
    return timeout;
  }

  createBulkhead(name: string, config: ResilienceConfig['bulkhead'] = {}) {
    const bulkhead = new Bulkhead({
      maxConcurrentCalls: config.maxConcurrentCalls || 25,
      maxWaitDuration: config.maxWaitDuration || 0,
    });
    
    this.bulkheads.set(name, bulkhead);
    return bulkhead;
  }

  async executeWithResilience<T>(
    name: string,
    fn: () => Promise<T>,
    config: ResilienceConfig = {}
  ): Promise<T> {
    const circuitBreaker = this.circuitBreakers.get(name) || this.createCircuitBreaker(name, config.circuitBreaker);
    const retry = this.retries.get(name) || this.createRetry(name, config.retry);
    const timeout = this.timeouts.get(name) || this.createTimeout(name, config.timeout);
    const bulkhead = this.bulkheads.get(name) || this.createBulkhead(name, config.bulkhead);

    return bulkhead.execute(() =>
      timeout.execute(() =>
        retry.execute(() =>
          circuitBreaker.execute(fn)
        )
      )
    );
  }

  getMetrics(name: string) {
    const circuitBreaker = this.circuitBreakers.get(name);
    const retry = this.retries.get(name);
    const timeout = this.timeouts.get(name);
    const bulkhead = this.bulkheads.get(name);

    return {
      circuitBreaker: circuitBreaker ? {
        state: circuitBreaker.getState(),
        metrics: circuitBreaker.getMetrics(),
      } : null,
      retry: retry ? retry.getMetrics() : null,
      timeout: timeout ? timeout.getMetrics() : null,
      bulkhead: bulkhead ? bulkhead.getMetrics() : null,
    };
  }
}

// Default resilience manager instance
export const resilienceManager = new ResilienceManager();

// Predefined configurations for different service types
export const resilienceConfigs = {
  auth: {
    circuitBreaker: {
      failureRateThreshold: 50,
      waitDurationInOpenState: 30000,
      slidingWindowSize: 10,
      minimumNumberOfCalls: 5,
    },
    retry: {
      maxAttempts: 3,
      waitDuration: 1000,
    },
    timeout: {
      duration: 5000,
    },
    bulkhead: {
      maxConcurrentCalls: 50,
    },
  },
  payment: {
    circuitBreaker: {
      failureRateThreshold: 30,
      waitDurationInOpenState: 60000,
      slidingWindowSize: 20,
      minimumNumberOfCalls: 10,
    },
    retry: {
      maxAttempts: 2,
      waitDuration: 2000,
    },
    timeout: {
      duration: 10000,
    },
    bulkhead: {
      maxConcurrentCalls: 25,
    },
  },
  ai: {
    circuitBreaker: {
      failureRateThreshold: 40,
      waitDurationInOpenState: 120000,
      slidingWindowSize: 5,
      minimumNumberOfCalls: 3,
    },
    retry: {
      maxAttempts: 1,
      waitDuration: 5000,
    },
    timeout: {
      duration: 30000,
    },
    bulkhead: {
      maxConcurrentCalls: 10,
    },
  },
  analytics: {
    circuitBreaker: {
      failureRateThreshold: 60,
      waitDurationInOpenState: 30000,
      slidingWindowSize: 15,
      minimumNumberOfCalls: 5,
    },
    retry: {
      maxAttempts: 2,
      waitDuration: 1000,
    },
    timeout: {
      duration: 5000,
    },
    bulkhead: {
      maxConcurrentCalls: 100,
    },
  },
  pdf: {
    circuitBreaker: {
      failureRateThreshold: 40,
      waitDurationInOpenState: 60000,
      slidingWindowSize: 10,
      minimumNumberOfCalls: 5,
    },
    retry: {
      maxAttempts: 2,
      waitDuration: 2000,
    },
    timeout: {
      duration: 15000,
    },
    bulkhead: {
      maxConcurrentCalls: 20,
    },
  },
};

export function resilience(): string {
  return 'resilience';
}
