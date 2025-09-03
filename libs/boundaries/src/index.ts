/**
 * Project Boundaries Configuration
 * 
 * This file defines the allowed dependencies between projects
 * to prevent unauthorized cross-team dependencies.
 */

export interface ProjectBoundary {
  name: string;
  allowedDependencies: string[];
  forbiddenDependencies: string[];
  team: string;
}

export const PROJECT_BOUNDARIES: ProjectBoundary[] = [
  {
    name: 'web',
    allowedDependencies: [
      'libs/ui-components',
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils'
    ],
    forbiddenDependencies: [
      'apps/backend/*',
      'apps/frontend/admin'
    ],
    team: 'frontend-team'
  },
  {
    name: 'admin',
    allowedDependencies: [
      'libs/ui-components',
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils'
    ],
    forbiddenDependencies: [
      'apps/backend/*',
      'apps/frontend/web'
    ],
    team: 'frontend-team'
  },
  {
    name: 'auth-service',
    allowedDependencies: [
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils',
      'libs/resilience'
    ],
    forbiddenDependencies: [
      'apps/frontend/*',
      'apps/backend/payment-service',
      'apps/backend/analytics-service',
      'apps/backend/ai-service',
      'apps/backend/pdf-service'
    ],
    team: 'backend-team'
  },
  {
    name: 'payment-service',
    allowedDependencies: [
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils',
      'libs/resilience'
    ],
    forbiddenDependencies: [
      'apps/frontend/*',
      'apps/backend/auth-service',
      'apps/backend/analytics-service',
      'apps/backend/ai-service',
      'apps/backend/pdf-service'
    ],
    team: 'backend-team'
  },
  {
    name: 'analytics-service',
    allowedDependencies: [
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils',
      'libs/resilience'
    ],
    forbiddenDependencies: [
      'apps/frontend/*',
      'apps/backend/auth-service',
      'apps/backend/payment-service',
      'apps/backend/ai-service',
      'apps/backend/pdf-service'
    ],
    team: 'data-team'
  },
  {
    name: 'ai-service',
    allowedDependencies: [
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils',
      'libs/resilience'
    ],
    forbiddenDependencies: [
      'apps/frontend/*',
      'apps/backend/auth-service',
      'apps/backend/payment-service',
      'apps/backend/analytics-service',
      'apps/backend/pdf-service'
    ],
    team: 'ai-team'
  },
  {
    name: 'pdf-service',
    allowedDependencies: [
      'libs/api-client',
      'libs/validation',
      'libs/constants',
      'libs/utils',
      'libs/resilience'
    ],
    forbiddenDependencies: [
      'apps/frontend/*',
      'apps/backend/auth-service',
      'apps/backend/payment-service',
      'apps/backend/analytics-service',
      'apps/backend/ai-service'
    ],
    team: 'backend-team'
  }
];

export const TEAM_BOUNDARIES = {
  'frontend-team': {
    projects: ['web', 'admin'],
    allowedLibs: ['libs/ui-components', 'libs/api-client', 'libs/validation', 'libs/constants', 'libs/utils'],
    forbiddenProjects: ['apps/backend/*']
  },
  'backend-team': {
    projects: ['auth-service', 'payment-service', 'pdf-service'],
    allowedLibs: ['libs/api-client', 'libs/validation', 'libs/constants', 'libs/utils', 'libs/resilience'],
    forbiddenProjects: ['apps/frontend/*']
  },
  'data-team': {
    projects: ['analytics-service'],
    allowedLibs: ['libs/api-client', 'libs/validation', 'libs/constants', 'libs/utils', 'libs/resilience'],
    forbiddenProjects: ['apps/frontend/*', 'apps/backend/auth-service', 'apps/backend/payment-service', 'apps/backend/ai-service', 'apps/backend/pdf-service']
  },
  'ai-team': {
    projects: ['ai-service'],
    allowedLibs: ['libs/api-client', 'libs/validation', 'libs/constants', 'libs/utils', 'libs/resilience'],
    forbiddenProjects: ['apps/frontend/*', 'apps/backend/auth-service', 'apps/backend/payment-service', 'apps/backend/analytics-service', 'apps/backend/pdf-service']
  },
  'platform-team': {
    projects: ['libs/*'],
    allowedLibs: ['libs/*'],
    forbiddenProjects: []
  }
};

export function validateProjectBoundary(projectName: string, dependency: string): boolean {
  const boundary = PROJECT_BOUNDARIES.find(b => b.name === projectName);
  if (!boundary) return true; // Allow if no boundary defined
  
  // Check if dependency is explicitly forbidden
  if (boundary.forbiddenDependencies.some(forbidden => 
    dependency.includes(forbidden.replace('*', ''))
  )) {
    return false;
  }
  
  // Check if dependency is explicitly allowed
  if (boundary.allowedDependencies.some(allowed => 
    dependency.includes(allowed.replace('*', ''))
  )) {
    return true;
  }
  
  // Default to false for safety
  return false;
}

export function getTeamForProject(projectName: string): string | null {
  const boundary = PROJECT_BOUNDARIES.find(b => b.name === projectName);
  return boundary ? boundary.team : null;
}

export function boundaries(): string {
  return 'boundaries';
}
