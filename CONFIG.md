# Configuration Files Guide

This document describes the configuration files for development tools used in this project.

## Table of Contents

- [TFLint Configuration](#tflint-configuration)
- [TFSec Configuration](#tfsec-configuration)
- [Terraform Docs Configuration](#terraform-docs-configuration)
- [Quick Start](#quick-start)

## TFLint Configuration

**File:** `.tflint.hcl`

TFLint is a Terraform linter that finds errors and possible problems in Terraform code.

### Features

- Terraform rule set (recommended preset)
- OCI provider plugin support
- Module inspection enabled
- Comprehensive rule coverage

### Usage

```bash
# Initialize tflint plugins (first time only)
make lint-init

# Run tflint on all modules
make lint

# Run tflint on a specific module
make lint-module MODULE=vcn

# Or use tflint directly
tflint --config .tflint.hcl --recursive
```

### Configuration Highlights

- **Module inspection**: Enabled to check module structure
- **OCI plugin**: Configured for Oracle Cloud Infrastructure provider
- **Rule set**: Uses recommended preset with all standard rules enabled
- **Format**: Default output format with colors enabled

### Customization

Edit `.tflint.hcl` to:
- Enable/disable specific rules
- Change output format
- Configure plugin settings
- Add custom rule configurations

## TFSec Configuration

**File:** `.tfsec.yml`

TFSec is a static analysis security scanner for Terraform code that checks for security misconfigurations.

### Features

- Minimum severity filtering (LOW)
- Exclude downloaded modules
- OCI-specific security checks
- Always Free tier compliance checking

### Usage

```bash
# Run tfsec security scan
make tfsec

# Or run all security scans (tfsec + checkov)
make security

# Or use tfsec directly
tfsec --config-file .tfsec.yml .
```

### Configuration Highlights

- **Minimum severity**: LOW (shows all issues)
- **Exclude directories**: `.terraform`, `.git`, examples (optional)
- **Exclude downloaded modules**: Enabled
- **OCI-specific**: Always Free tier compliance checking enabled

### Customization

Edit `.tfsec.yml` to:
- Exclude specific checks (uncomment `excluded_checks`)
- Change minimum severity level
- Include/exclude directories
- Override severity for specific checks

### Ignoring Checks in Code

To ignore a specific check in your Terraform code:

```hcl
# tfsec:ignore:OCI-001
resource "oci_objectstorage_bucket" "example" {
  public_access_type = "ObjectRead"
}
```

Or for a specific line:

```hcl
public_access_type = "ObjectRead"  # tfsec:ignore:OCI-001
```

## Terraform Docs Configuration

**File:** `.terraform-docs.yml`

Terraform-docs automatically generates documentation from Terraform modules.

### Features

- Markdown table format
- Auto-inject into README.md
- Comprehensive content (inputs, outputs, providers, resources)
- Sorted by name

### Usage

```bash
# Generate docs for all modules
make docs

# Generate docs for a specific module
make docs-module MODULE=vcn

# Or use terraform-docs directly
terraform-docs --config .terraform-docs.yml .
```

### Configuration Highlights

- **Formatter**: Markdown table format
- **Output file**: README.md (auto-inject)
- **Output mode**: Inject (adds/updates sections in existing README)
- **Show sections**: All (inputs, outputs, providers, requirements, resources)
- **Sort**: Enabled, sorted by name

### Customization

Edit `.terraform-docs.yml` to:
- Change output format (markdown, json, etc.)
- Modify section visibility
- Change output file location
- Customize section names
- Adjust sorting options

### Output Modes

- **inject**: Adds/updates sections in existing README.md
- **replace**: Replaces entire README.md
- **create**: Creates new README.md

## Quick Start

### 1. Install Tools

```bash
# Install all tools
make install-tools

# Or install individually
make install-tflint
make install-tfsec
make install-terraform-docs
```

### 2. Initialize TFLint

```bash
# Initialize tflint plugins (first time only)
make lint-init
```

### 3. Run Checks

```bash
# Format check
make fmt-check

# Validate
make validate-modules

# Lint
make lint

# Security scan
make security

# Generate docs
make docs
```

### 4. CI/CD Integration

```bash
# Pre-commit checks
make pre-commit

# Full CI checks
make ci
```

## Configuration File Locations

All configuration files are in the project root:

```
.
├── .tflint.hcl          # TFLint configuration
├── .tfsec.yml           # TFSec configuration
├── .terraform-docs.yml  # Terraform-docs configuration
└── Makefile             # Makefile with all commands
```

## Tool Versions

Check installed tool versions:

```bash
make check-versions
```

## Troubleshooting

### TFLint Plugin Issues

If tflint can't find the OCI plugin:

```bash
# Re-initialize plugins
make lint-init

# Or manually
tflint --init
```

### TFSec Configuration Not Found

If tfsec can't find the config file:

```bash
# Use explicit config file path
tfsec --config-file .tfsec.yml .
```

### Terraform Docs Not Updating README

If terraform-docs isn't updating README.md:

1. Check output mode in `.terraform-docs.yml` (should be `inject`)
2. Ensure README.md exists
3. Check file permissions

## Additional Resources

- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/)
- [Terraform Docs Documentation](https://terraform-docs.io/)
