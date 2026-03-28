# Terraform Workspace Management

This project includes workspace management functionality to help you work with different environments (development, testing, staging, production).

## Overview

Workspace management ensures that:
- Only valid environments can be used: `development`, `testing`, `staging`, `production`
- Workspaces are automatically created if they don't exist
- Easy switching between environments

## Usage Methods

### Method 1: Using Makefile (Recommended)

```bash
# Switch to or create a workspace
make workspace ENV=production

# List all workspaces
make workspace-list

# Show current workspace
make workspace-show

# Run terraform commands with workspace
make plan-workspace ENV=production
make apply-workspace ENV=production
```

### Method 2: Using Wrapper Script

The wrapper script adds `-e` flag support to Terraform commands:

```bash
# Plan with production workspace
./terraform-wrapper.sh -e production plan

# Apply with staging workspace
./terraform-wrapper.sh -e staging apply

# Show state with development workspace
./terraform-wrapper.sh -e development show
```

### Method 3: Using Workspace Script Directly

```bash
# Switch to production workspace (creates if doesn't exist)
./scripts/terraform-workspace.sh -e production

# Then run terraform commands normally
terraform plan
terraform apply
```

## Valid Environments

Only the following environments are allowed:
- `development`
- `testing`
- `staging`
- `production`

Any other environment name will result in an error.

## Examples

### Example 1: Working with Production

```bash
# Switch to production workspace
make workspace ENV=production

# Or use the wrapper
./terraform-wrapper.sh -e production plan
./terraform-wrapper.sh -e production apply
```

### Example 2: Working with Development

```bash
# Switch to development workspace
make workspace ENV=development

# Run terraform commands
terraform plan
terraform apply
```

### Example 3: Creating a New Workspace

```bash
# This will create the workspace if it doesn't exist
make workspace ENV=staging

# Verify it was created
make workspace-list
```

## How It Works

1. **Validation**: The script validates that the environment is one of the allowed values
2. **Check**: It checks if the workspace already exists
3. **Create**: If the workspace doesn't exist, it creates it
4. **Switch**: It switches to the specified workspace
5. **Verify**: It verifies that the switch was successful

## Integration with CI/CD

You can use workspace management in CI/CD pipelines:

```bash
#!/bin/bash
ENVIRONMENT=${1:-development}

# Validate and switch to workspace
make workspace ENV=$ENVIRONMENT

# Run terraform commands
terraform init
terraform plan
terraform apply -auto-approve
```

## Troubleshooting

### Error: "Invalid environment"

Make sure you're using one of the valid environments:
- development
- testing
- staging
- production

### Error: "terraform command not found"

Make sure Terraform is installed and in your PATH.

### Workspace not switching

Make sure you've run `terraform init` first, as workspaces require an initialized Terraform directory.

## Best Practices

1. **Always use workspace management**: Don't manually create workspaces
2. **Use environment-specific variables**: Use `.tfvars` files for each environment
3. **Verify before applying**: Always check which workspace you're on before applying changes
4. **Use in CI/CD**: Integrate workspace management into your deployment pipelines

## Related Files

- `scripts/terraform-workspace.sh` - Workspace management script
- `terraform-wrapper.sh` - Terraform wrapper with `-e` flag support
- `Makefile` - Contains workspace management targets
