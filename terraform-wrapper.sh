#!/bin/bash

# Terraform Wrapper Script
# Supports -e flag for workspace management
# Usage: ./terraform-wrapper.sh -e production plan
# Usage: ./terraform-wrapper.sh -e production apply

set -e

# Valid environments
VALID_ENVIRONMENTS=("development" "testing" "staging" "production")

# Parse arguments
ENVIRONMENT=""
TERRAFORM_ARGS=()
HAS_E_FLAG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -e)
            ENVIRONMENT="$2"
            HAS_E_FLAG=true
            shift 2
            ;;
        *)
            TERRAFORM_ARGS+=("$1")
            shift
            ;;
    esac
done

# If -e flag is provided, manage workspace
if [ "$HAS_E_FLAG" = true ]; then
    if [ -z "$ENVIRONMENT" ]; then
        echo "Error: Environment is required after -e flag"
        echo "Valid environments: ${VALID_ENVIRONMENTS[*]}"
        exit 1
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

    # Use workspace management script
    if [ -f "./scripts/terraform-workspace.sh" ]; then
        ./scripts/terraform-workspace.sh -e "$ENVIRONMENT"
    else
        echo "Error: terraform-workspace.sh not found"
        exit 1
    fi
fi

# Execute terraform with remaining arguments
if [ ${#TERRAFORM_ARGS[@]} -eq 0 ]; then
    terraform
else
    terraform "${TERRAFORM_ARGS[@]}"
fi
