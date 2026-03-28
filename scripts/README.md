# Scripts Directory

This directory contains utility scripts for managing Terraform workspaces and operations.

## terraform-workspace.sh

Manages Terraform workspaces with environment validation.

### Usage

```bash
./scripts/terraform-workspace.sh -e <environment>
```

### Valid Environments

- `development`
- `testing`
- `staging`
- `production`

### Features

- Validates that the environment is one of the allowed values
- Creates the workspace if it doesn't exist
- Switches to the workspace if it exists
- Shows current workspace status

### Examples

```bash
# Switch to production workspace (creates if doesn't exist)
./scripts/terraform-workspace.sh -e production

# Switch to development workspace
./scripts/terraform-workspace.sh -e development
```

## terraform-plan.sh

Runs Terraform plan with project and environment support, generating properly formatted plan files.

### Usage

```bash
./scripts/terraform-plan.sh -p <project/path> -e <environment> [terraform-args...]
```

### Options

- `-p <path>` - Project path (e.g., `demo/vpc`)
- `-e <env>` - Environment (development, testing, staging, production)
- Additional terraform arguments are passed through

### Plan File Format

The script generates plan files with the following format:
```
terraform-plan.<project-name>.<environment>.<pid>.tfplan
```

**Example:**
- Input: `-p demo/vpc -e production`
- Output: `terraform-plan.demo-vpc.production.48868.tfplan`

### Features

- Validates environment name
- Automatically creates workspace if it doesn't exist
- Switches to the specified workspace
- Generates plan files in `/tmp` (or `$TMPDIR`) with proper naming
- Automatically adds `-var-file=terraform.tfvars` if it exists
- Automatically adds `-var=environment=<env>` variable

### Examples

```bash
# Basic plan
./scripts/terraform-plan.sh -p demo/vpc -e production

# Plan with custom var-file
./scripts/terraform-plan.sh -p demo/vpc -e production -var-file=custom.tfvars

# Plan with additional variables
./scripts/terraform-plan.sh -p demo/vpc -e production -var="key=value"
```

### Integration with Makefile

```bash
# Using Makefile
make terraform -- plan -p demo/vpc -e production

# Direct usage
./scripts/terraform-plan.sh -p demo/vpc -e production
```

## terraform-wrapper.sh

A wrapper script that adds `-e` flag support to Terraform commands.

### Usage

```bash
./terraform-wrapper.sh -e <environment> <terraform-command> [terraform-args...]
```

### Examples

```bash
# Plan with production workspace
./terraform-wrapper.sh -e production plan

# Apply with staging workspace
./terraform-wrapper.sh -e staging apply

# Show current state with development workspace
./terraform-wrapper.sh -e development show
```

### Features

- Automatically switches to the specified workspace before running Terraform commands
- Validates environment names
- Creates workspace if it doesn't exist
- Passes all other arguments to Terraform

## Makefile Integration

The Makefile includes workspace management targets:

```bash
# Switch to a workspace
make workspace ENV=production

# List all workspaces
make workspace-list

# Show current workspace
make workspace-show

# Plan with workspace
make plan-workspace ENV=production

# Apply with workspace
make apply-workspace ENV=production

# Plan with project and environment
make terraform -- plan -p demo/vpc -e production
make plan-project P=demo/vpc E=production
```
