#!/bin/bash

# Terraform Plan Script with Project and Environment Support
# Usage: terraform-plan.sh -p <project/path> -e <environment> [terraform-args...]
# Example: terraform-plan.sh -p demo/vpc -e production

set -e

# Valid environments
VALID_ENVIRONMENTS=("development" "testing" "staging" "production")

# Variables
PROJECT_PATH=""
ENVIRONMENT=""
TERRAFORM_ARGS=()
HAS_P_FLAG=false
HAS_E_FLAG=false

# Function to show usage
usage() {
    echo "Usage: $0 -p <project/path> -e <environment> [terraform-args...]"
    echo ""
    echo "Options:"
    echo "  -p <path>     Project path (e.g., demo/vpc)"
    echo "  -e <env>      Environment (development, testing, staging, production)"
    echo "  -h            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -p demo/vpc -e production"
    echo "  $0 -p demo/vpc -e production -var-file=custom.tfvars"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p)
            PROJECT_PATH="$2"
            HAS_P_FLAG=true
            shift 2
            ;;
        -e)
            ENVIRONMENT="$2"
            HAS_E_FLAG=true
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            TERRAFORM_ARGS+=("$1")
            shift
            ;;
    esac
done

# Validate required flags
if [ "$HAS_P_FLAG" = false ] || [ -z "$PROJECT_PATH" ]; then
    echo "Error: -p flag is required"
    usage
fi

if [ "$HAS_E_FLAG" = false ] || [ -z "$ENVIRONMENT" ]; then
    echo "Error: -e flag is required"
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

# Set terraform directory
TERRAFORM_DIR="terraform/$PROJECT_PATH"

# Normalize project path for filename (replace / with -)
# This will be used in the plan filename: terraform-plan.<project-name>.<environment>.<pid>.tfplan
PROJECT_NAME=$(echo "$PROJECT_PATH" | tr '/' '-')

# Check if terraform directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "Error: Terraform directory not found: $TERRAFORM_DIR"
    exit 1
fi

# Get current workspace (default to 'default' if not set)
CURRENT_WORKSPACE=$(cd "$TERRAFORM_DIR" && terraform workspace show 2>/dev/null || echo "default")

# Check if workspace exists, create if not
WORKSPACE_EXISTS=false
(cd "$TERRAFORM_DIR" && terraform workspace list 2>/dev/null | grep -q "^\s*${ENVIRONMENT}\s*$") && WORKSPACE_EXISTS=true

if [ "$WORKSPACE_EXISTS" = false ]; then
    echo "Workspace '$ENVIRONMENT' does not exist. Creating it..."
    (cd "$TERRAFORM_DIR" && terraform workspace new "$ENVIRONMENT" >/dev/null 2>&1)
    echo "Workspace '$ENVIRONMENT' created successfully"
else
    if [ "$CURRENT_WORKSPACE" != "$ENVIRONMENT" ]; then
        echo "Switching to workspace '$ENVIRONMENT'..."
        (cd "$TERRAFORM_DIR" && terraform workspace select "$ENVIRONMENT" >/dev/null 2>&1)
    fi
fi

# Generate plan filename
# Format: terraform-plan.<project-name>.<environment>.<pid>.tfplan
# Example: terraform-plan.demo-vpc.production.48868.tfplan
PLAN_PID=$$
PLAN_FILENAME="terraform-plan.${PROJECT_NAME}.${ENVIRONMENT}.${PLAN_PID}.tfplan"
PLAN_TMP_DIR="${TMPDIR:-/tmp}"
PLAN_FILE="${PLAN_TMP_DIR}/${PLAN_FILENAME}"

# Build terraform command
TERRAFORM_CMD="terraform -chdir=${TERRAFORM_DIR}"

# Add default var-file if it exists and not already specified
HAS_VAR_FILE=false
for arg in "${TERRAFORM_ARGS[@]}"; do
    if [[ "$arg" == "-var-file"* ]] || [[ "$arg" == "-var="* ]]; then
        HAS_VAR_FILE=true
        break
    fi
done

if [ "$HAS_VAR_FILE" = false ] && [ -f "${TERRAFORM_DIR}/terraform.tfvars" ]; then
    TERRAFORM_CMD="${TERRAFORM_CMD} -var-file=terraform.tfvars"
fi

# Add environment variable
TERRAFORM_CMD="${TERRAFORM_CMD} -var=environment=${ENVIRONMENT}"

# Add plan command and output file
TERRAFORM_CMD="${TERRAFORM_CMD} plan -out=${PLAN_FILE}"

# Add remaining terraform arguments (excluding plan and -out if already present)
for arg in "${TERRAFORM_ARGS[@]}"; do
    # Skip if it's already plan or -out
    if [[ "$arg" != "plan" ]] && [[ "$arg" != "-out"* ]]; then
        TERRAFORM_CMD="${TERRAFORM_CMD} ${arg}"
    fi
done

# Execute terraform plan
PROJECT_DIR=$(dirname "$PROJECT_PATH")
if [ "$PROJECT_DIR" = "." ]; then
    PROJECT_DISPLAY=$(basename "$PROJECT_PATH")
else
    PROJECT_DISPLAY=$(basename "$PROJECT_DIR")
fi

echo "✓ Resource $(basename $PROJECT_PATH) found in project ${PROJECT_DISPLAY}"
echo "Generating Terraform plan..."
echo "Running: ${TERRAFORM_CMD}"

eval "$TERRAFORM_CMD"

echo ""
echo "✓ Plan generated: ${PLAN_FILE}"
echo "  Filename format: terraform-plan.${PROJECT_NAME}.${ENVIRONMENT}.${PLAN_PID}.tfplan"
echo "  To apply: terraform -chdir=${TERRAFORM_DIR} apply ${PLAN_FILE}"
