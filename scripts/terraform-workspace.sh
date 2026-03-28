#!/bin/bash

# Terraform Workspace Management Script
# Usage: terraform-workspace.sh -e <environment>
# Valid environments: development, testing, staging, production

set -e

# Valid environments
VALID_ENVIRONMENTS=("development" "testing" "staging" "production")

# Function to show usage
usage() {
    echo "Usage: $0 -e <environment>"
    echo ""
    echo "Valid environments:"
    for env in "${VALID_ENVIRONMENTS[@]}"; do
        echo "  - $env"
    done
    echo ""
    echo "Examples:"
    echo "  $0 -e production"
    echo "  $0 -e development"
    exit 1
}

# Parse arguments
ENVIRONMENT=""
while getopts "e:h" opt; do
    case $opt in
        e)
            ENVIRONMENT="$OPTARG"
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

# Check if environment is provided
if [ -z "$ENVIRONMENT" ]; then
    echo "Error: Environment is required"
    usage
fi

# Validate environment
VALID=false
for env in "${VALID_ENVIRONMENTS[@]}"; do
    if [ "$ENVIRONMENT" = "$env" ]; then
        VALID=true
        break
    fi
done

if [ "$VALID" = false ]; then
    echo "Error: Invalid environment '$ENVIRONMENT'"
    echo "Valid environments are: ${VALID_ENVIRONMENTS[*]}"
    exit 1
fi

# Check if terraform is available
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform command not found"
    exit 1
fi

# Get current workspace
CURRENT_WORKSPACE=$(terraform workspace show 2>/dev/null || echo "default")

# Check if workspace exists
WORKSPACE_EXISTS=false
terraform workspace list 2>/dev/null | grep -q "^\s*${ENVIRONMENT}\s*$" && WORKSPACE_EXISTS=true

if [ "$WORKSPACE_EXISTS" = false ]; then
    echo "Workspace '$ENVIRONMENT' does not exist. Creating it..."
    terraform workspace new "$ENVIRONMENT"
    echo "Workspace '$ENVIRONMENT' created successfully"
else
    if [ "$CURRENT_WORKSPACE" != "$ENVIRONMENT" ]; then
        echo "Switching to workspace '$ENVIRONMENT'..."
        terraform workspace select "$ENVIRONMENT"
        echo "Switched to workspace '$ENVIRONMENT'"
    else
        echo "Already on workspace '$ENVIRONMENT'"
    fi
fi

# Verify current workspace
CURRENT_WORKSPACE=$(terraform workspace show)
if [ "$CURRENT_WORKSPACE" = "$ENVIRONMENT" ]; then
    echo "✓ Current workspace: $CURRENT_WORKSPACE"
    exit 0
else
    echo "Error: Failed to switch to workspace '$ENVIRONMENT'"
    exit 1
fi
