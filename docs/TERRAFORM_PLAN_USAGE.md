# Terraform Plan with Project and Environment

This document explains how to use the `terraform-plan.sh` script to generate Terraform plans with proper file naming.

## Overview

The `terraform-plan.sh` script provides a standardized way to run Terraform plan commands with:
- Project path support (`-p` flag)
- Environment validation (`-e` flag)
- Automatic workspace management
- Properly formatted plan file names

## Plan File Naming

The script generates plan files with the following format:
```
terraform-plan.<project-name>.<environment>.<pid>.tfplan
```

### Format Details

- **project-name**: Project path with `/` replaced by `-` (e.g., `demo/vpc` → `demo-vpc`)
- **environment**: One of: `development`, `testing`, `staging`, `production`
- **pid**: Process ID for uniqueness
- **Extension**: `.tfplan`

### Examples

| Command | Generated Filename |
|---------|-------------------|
| `-p demo/vpc -e production` | `terraform-plan.demo-vpc.production.48868.tfplan` |
| `-p demo/compute -e staging` | `terraform-plan.demo-compute.staging.48901.tfplan` |
| `-p app/database -e development` | `terraform-plan.app-database.development.48925.tfplan` |

## Usage

### Method 1: Using Makefile

```bash
# Using the terraform target
make terraform -- plan -p demo/vpc -e production

# Using the plan-project target
make plan-project P=demo/vpc E=production
```

### Method 2: Direct Script Usage

```bash
# Basic usage
./scripts/terraform-plan.sh -p demo/vpc -e production

# With additional terraform arguments
./scripts/terraform-plan.sh -p demo/vpc -e production -var-file=custom.tfvars
```

## Features

### Automatic Workspace Management

- Validates environment name (must be one of: development, testing, staging, production)
- Creates workspace if it doesn't exist
- Switches to the specified workspace before running plan

### Automatic Variable Injection

- Automatically adds `-var-file=terraform.tfvars` if the file exists
- Automatically adds `-var=environment=<environment>` variable

### Directory Structure

The script expects the following directory structure:
```
terraform/
  <project-path>/
    main.tf
    variables.tf
    terraform.tfvars (optional)
```

Example:
```
terraform/
  demo/
    vpc/
      main.tf
      variables.tf
      terraform.tfvars
```

## Command Execution

When you run:
```bash
make terraform -- plan -p demo/vpc -e production
```

The script will:
1. Validate that `production` is a valid environment
2. Check if `terraform/demo/vpc` directory exists
3. Create or switch to `production` workspace
4. Generate plan file: `terraform-plan.demo-vpc.production.<pid>.tfplan`
5. Execute: `terraform -chdir=terraform/demo/vpc plan -var-file=terraform.tfvars -var=environment=production -out=/tmp/terraform-plan.demo-vpc.production.<pid>.tfplan`

## Applying Plans

After generating a plan, you can apply it using:

```bash
terraform -chdir=terraform/demo/vpc apply /tmp/terraform-plan.demo-vpc.production.48868.tfplan
```

Or use the path shown in the script output.

## Error Handling

The script will exit with an error if:
- `-p` or `-e` flags are missing
- Environment is not one of the valid values
- Terraform directory doesn't exist
- Terraform command is not found

## Integration Examples

### CI/CD Pipeline

```bash
#!/bin/bash
PROJECT=${1:-demo/vpc}
ENV=${2:-production}

./scripts/terraform-plan.sh -p "$PROJECT" -e "$ENV"
PLAN_FILE=$(ls -t /tmp/terraform-plan.*.tfplan | head -1)
terraform -chdir="terraform/$PROJECT" apply "$PLAN_FILE"
```

### Local Development

```bash
# Development environment
make terraform -- plan -p demo/vpc -e development

# Production environment
make terraform -- plan -p demo/vpc -e production
```

## Troubleshooting

### Error: "Terraform directory not found"

Make sure the directory structure matches:
```
terraform/<project-path>/
```

### Error: "Invalid environment"

Use one of the valid environments:
- `development`
- `testing`
- `staging`
- `production`

### Plan file not found

Plan files are stored in `/tmp` (or `$TMPDIR`). Check the script output for the exact path.
