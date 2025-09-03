import { TSESTree } from '@typescript-eslint/utils';
import { createRule } from '@typescript-eslint/utils/ts-eslint';

export const projectBoundariesRule = createRule({
  name: 'project-boundaries',
  meta: {
    type: 'problem',
    docs: {
      description: 'Enforce project boundaries to prevent unauthorized dependencies',
      recommended: 'error',
    },
    messages: {
      forbiddenDependency: 'Project "{{projectName}}" is not allowed to depend on "{{dependency}}". This violates team boundaries.',
      teamBoundaryViolation: 'Team "{{team}}" is not allowed to access "{{forbiddenProject}}".',
    },
    schema: [],
  },
  defaultOptions: [],
  create(context) {
    const filename = context.getFilename();
    const projectName = getProjectNameFromPath(filename);
    
    return {
      ImportDeclaration(node: TSESTree.ImportDeclaration) {
        const importPath = node.source.value as string;
        
        // Skip relative imports within the same project
        if (importPath.startsWith('./') || importPath.startsWith('../')) {
          return;
        }
        
        // Check if this is a cross-project import
        if (importPath.startsWith('@monorepo-polyglot/') || importPath.startsWith('apps/') || importPath.startsWith('libs/')) {
          const dependency = extractDependencyFromImport(importPath);
          
          if (!validateProjectBoundary(projectName, dependency)) {
            context.report({
              node,
              messageId: 'forbiddenDependency',
              data: {
                projectName,
                dependency,
              },
            });
          }
        }
      },
    };
  },
});

function getProjectNameFromPath(filePath: string): string {
  // Extract project name from file path
  const pathParts = filePath.split('/');
  
  if (pathParts.includes('apps')) {
    const appsIndex = pathParts.indexOf('apps');
    if (appsIndex + 2 < pathParts.length) {
      return pathParts[appsIndex + 2]; // apps/frontend/web -> web
    }
  }
  
  if (pathParts.includes('libs')) {
    const libsIndex = pathParts.indexOf('libs');
    if (libsIndex + 1 < pathParts.length) {
      return pathParts[libsIndex + 1]; // libs/api-client -> api-client
    }
  }
  
  return 'unknown';
}

function extractDependencyFromImport(importPath: string): string {
  // Extract the actual dependency path from import
  if (importPath.startsWith('@monorepo-polyglot/')) {
    return importPath.replace('@monorepo-polyglot/', '');
  }
  
  if (importPath.startsWith('apps/')) {
    return importPath;
  }
  
  if (importPath.startsWith('libs/')) {
    return importPath;
  }
  
  return importPath;
}

function validateProjectBoundary(projectName: string, dependency: string): boolean {
  // Import the boundaries configuration
  const boundaries = {
    'web': {
      allowedDependencies: [
        'libs/ui-components',
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils'
      ],
      forbiddenDependencies: [
        'apps/backend/',
        'apps/frontend/admin'
      ]
    },
    'admin': {
      allowedDependencies: [
        'libs/ui-components',
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils'
      ],
      forbiddenDependencies: [
        'apps/backend/',
        'apps/frontend/web'
      ]
    },
    'auth-service': {
      allowedDependencies: [
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils',
        'libs/resilience'
      ],
      forbiddenDependencies: [
        'apps/frontend/',
        'apps/backend/payment-service',
        'apps/backend/analytics-service',
        'apps/backend/ai-service',
        'apps/backend/pdf-service'
      ]
    },
    'payment-service': {
      allowedDependencies: [
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils',
        'libs/resilience'
      ],
      forbiddenDependencies: [
        'apps/frontend/',
        'apps/backend/auth-service',
        'apps/backend/analytics-service',
        'apps/backend/ai-service',
        'apps/backend/pdf-service'
      ]
    },
    'analytics-service': {
      allowedDependencies: [
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils',
        'libs/resilience'
      ],
      forbiddenDependencies: [
        'apps/frontend/',
        'apps/backend/auth-service',
        'apps/backend/payment-service',
        'apps/backend/ai-service',
        'apps/backend/pdf-service'
      ]
    },
    'ai-service': {
      allowedDependencies: [
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils',
        'libs/resilience'
      ],
      forbiddenDependencies: [
        'apps/frontend/',
        'apps/backend/auth-service',
        'apps/backend/payment-service',
        'apps/backend/analytics-service',
        'apps/backend/pdf-service'
      ]
    },
    'pdf-service': {
      allowedDependencies: [
        'libs/api-client',
        'libs/validation',
        'libs/constants',
        'libs/utils',
        'libs/resilience'
      ],
      forbiddenDependencies: [
        'apps/frontend/',
        'apps/backend/auth-service',
        'apps/backend/payment-service',
        'apps/backend/analytics-service',
        'apps/backend/ai-service'
      ]
    }
  };
  
  const boundary = boundaries[projectName as keyof typeof boundaries];
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
