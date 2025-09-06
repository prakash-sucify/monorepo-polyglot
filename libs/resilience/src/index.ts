import CircuitBreaker from 'opossum';

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
  private retryCounts: Map<string, number> = new Map();
  private timeoutIds: Map<string, NodeJS.Timeout> = new Map();
  private activeCalls: Map<string, number> = new Map();

  createCircuitBreaker(name: string, config: ResilienceConfig['circuitBreaker'] = {}) {
    const circuitBreaker = new CircuitBreaker(
      async () => {},
      {
        errorThresholdPercentage: config.failureRateThreshold || 50,
        resetTimeout: config.waitDurationInOpenState || 60000,
        rollingCountTimeout: config.slidingWindowSize || 10000,
        rollingCountBuckets: Math.ceil((config.slidingWindowSize || 10000) / 1000),
        volumeThreshold: config.minimumNumberOfCalls || 5,
      }
    );
    
    this.circuitBreakers.set(name, circuitBreaker);
    return circuitBreaker;
  }

  async executeWithRetry<T>(
    name: string,
    fn: () => Promise<T>,
    config: ResilienceConfig['retry'] = {}
  ): Promise<T> {
    const maxAttempts = config.maxAttempts || 3;
    const waitDuration = config.waitDuration || 1000;
    const retryExceptions = config.retryExceptions || ['Error'];

    let lastError: Error;
    
    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        const result = await fn();
        this.retryCounts.set(name, attempt - 1);
        return result;
      } catch (error) {
        lastError = error as Error;
        
        if (attempt === maxAttempts) {
          break;
        }

        const shouldRetry = retryExceptions.some(exception => 
          error instanceof Error && error.constructor.name === exception
        );

        if (!shouldRetry) {
          break;
        }

        await new Promise(resolve => setTimeout(resolve, waitDuration * attempt));
      }
    }

    throw lastError!;
  }

  async executeWithTimeout<T>(
    name: string,
    fn: () => Promise<T>,
    config: ResilienceConfig['timeout'] = {}
  ): Promise<T> {
    const duration = config.duration || 5000;

    return new Promise((resolve, reject) => {
      const timeoutId = setTimeout(() => {
        reject(new Error(`Operation timed out after ${duration}ms`));
      }, duration);

      this.timeoutIds.set(name, timeoutId);

      fn()
        .then(result => {
          clearTimeout(timeoutId);
          this.timeoutIds.delete(name);
          resolve(result);
        })
        .catch(error => {
          clearTimeout(timeoutId);
          this.timeoutIds.delete(name);
          reject(error);
        });
    });
  }

  async executeWithBulkhead<T>(
    name: string,
    fn: () => Promise<T>,
    config: ResilienceConfig['bulkhead'] = {}
  ): Promise<T> {
    const maxConcurrentCalls = config.maxConcurrentCalls || 25;
    const maxWaitDuration = config.maxWaitDuration || 0;

    const currentCalls = this.activeCalls.get(name) || 0;

    if (currentCalls >= maxConcurrentCalls) {
      if (maxWaitDuration > 0) {
        await new Promise(resolve => setTimeout(resolve, maxWaitDuration));
        if ((this.activeCalls.get(name) || 0) >= maxConcurrentCalls) {
          throw new Error('Bulkhead: Maximum concurrent calls exceeded');
        }
      } else {
        throw new Error('Bulkhead: Maximum concurrent calls exceeded');
      }
    }

    this.activeCalls.set(name, currentCalls + 1);

    try {
      const result = await fn();
      return result;
    } finally {
      this.activeCalls.set(name, (this.activeCalls.get(name) || 1) - 1);
    }
  }

  async executeWithResilience<T>(
    name: string,
    fn: () => Promise<T>,
    config: ResilienceConfig = {}
  ): Promise<T> {
    const circuitBreaker = this.circuitBreakers.get(name) || this.createCircuitBreaker(name, config.circuitBreaker);
    
    const wrappedFn = async () => {
      return this.executeWithBulkhead(name, fn, config.bulkhead);
    };

    const timeoutFn = async () => {
      return this.executeWithTimeout(name, wrappedFn, config.timeout);
    };

    const retryFn = async () => {
      return this.executeWithRetry(name, timeoutFn, config.retry);
    };

    return new Promise((resolve, reject) => {
      circuitBreaker.fire(retryFn)
        .then(resolve)
        .catch(reject);
    });
  }

  getMetrics(name: string) {
    const circuitBreaker = this.circuitBreakers.get(name);
    const retryCount = this.retryCounts.get(name) || 0;
    const activeCalls = this.activeCalls.get(name) || 0;

    return {
      circuitBreaker: circuitBreaker ? {
        state: circuitBreaker.state,
        stats: circuitBreaker.stats,
      } : null,
      retry: {
        attempts: retryCount,
      },
      bulkhead: {
        activeCalls,
      },
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
      slidingWindowSize: 10000,
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
      slidingWindowSize: 20000,
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
      slidingWindowSize: 5000,
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
      slidingWindowSize: 15000,
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
      slidingWindowSize: 10000,
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