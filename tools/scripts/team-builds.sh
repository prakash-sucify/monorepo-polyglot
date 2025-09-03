#!/bin/bash

# Team-specific build scripts to prevent cross-team dependencies

set -e

TEAM=${1:-""}
ACTION=${2:-"build"}

print_usage() {
    echo "Usage: $0 <team> <action>"
    echo ""
    echo "Teams:"
    echo "  frontend  - Frontend team (web, admin)"
    echo "  backend   - Backend team (auth, payment, pdf)"
    echo "  data      - Data team (analytics)"
    echo "  ai        - AI team (ai-service)"
    echo "  platform  - Platform team (libs, tools)"
    echo ""
    echo "Actions:"
    echo "  build     - Build team projects"
    echo "  test      - Test team projects"
    echo "  lint      - Lint team projects"
    echo "  dev       - Start development servers"
    echo ""
    echo "Examples:"
    echo "  $0 frontend build"
    echo "  $0 backend test"
    echo "  $0 data dev"
}

if [ -z "$TEAM" ] || [ -z "$ACTION" ]; then
    print_usage
    exit 1
fi

case $TEAM in
    "frontend")
        echo "🏗️  Building Frontend Team Projects..."
        case $ACTION in
            "build")
                npx nx build web admin
                npx nx build ui-components
                ;;
            "test")
                npx nx test web admin
                npx nx test ui-components
                ;;
            "lint")
                npx nx lint web admin
                npx nx lint ui-components
                ;;
            "dev")
                npx nx serve web &
                npx nx serve admin &
                wait
                ;;
            *)
                echo "❌ Unknown action: $ACTION"
                exit 1
                ;;
        esac
        ;;
    "backend")
        echo "🏗️  Building Backend Team Projects..."
        case $ACTION in
            "build")
                npx nx build auth-service payment-service pdf-service
                npx nx build api-client validation constants utils resilience
                ;;
            "test")
                npx nx test auth-service payment-service pdf-service
                npx nx test api-client validation constants utils resilience
                ;;
            "lint")
                npx nx lint auth-service payment-service pdf-service
                npx nx lint api-client validation constants utils resilience
                ;;
            "dev")
                npx nx serve auth-service &
                npx nx serve payment-service &
                npx nx serve pdf-service &
                wait
                ;;
            *)
                echo "❌ Unknown action: $ACTION"
                exit 1
                ;;
        esac
        ;;
    "data")
        echo "🏗️  Building Data Team Projects..."
        case $ACTION in
            "build")
                npx nx build analytics-service
                npx nx build api-client validation constants utils resilience
                ;;
            "test")
                npx nx test analytics-service
                npx nx test api-client validation constants utils resilience
                ;;
            "lint")
                npx nx lint analytics-service
                npx nx lint api-client validation constants utils resilience
                ;;
            "dev")
                npx nx serve analytics-service
                ;;
            *)
                echo "❌ Unknown action: $ACTION"
                exit 1
                ;;
        esac
        ;;
    "ai")
        echo "🏗️  Building AI Team Projects..."
        case $ACTION in
            "build")
                npx nx build ai-service
                npx nx build api-client validation constants utils resilience
                ;;
            "test")
                npx nx test ai-service
                npx nx test api-client validation constants utils resilience
                ;;
            "lint")
                npx nx lint ai-service
                npx nx lint api-client validation constants utils resilience
                ;;
            "dev")
                npx nx serve ai-service
                ;;
            *)
                echo "❌ Unknown action: $ACTION"
                exit 1
                ;;
        esac
        ;;
    "platform")
        echo "🏗️  Building Platform Team Projects..."
        case $ACTION in
            "build")
                npx nx build-many --projects=tag:scope:shared
                ;;
            "test")
                npx nx test-many --projects=tag:scope:shared
                ;;
            "lint")
                npx nx lint-many --projects=tag:scope:shared
                ;;
            "dev")
                echo "Platform team doesn't have dev servers"
                ;;
            *)
                echo "❌ Unknown action: $ACTION"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "❌ Unknown team: $TEAM"
        print_usage
        exit 1
        ;;
esac

echo "✅ $TEAM team $ACTION completed successfully!"
