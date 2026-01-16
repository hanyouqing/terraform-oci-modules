# Terraform OCI Modules

A collection of production-ready Terraform modules for Oracle Cloud Infrastructure (OCI) Always Free resources.

## Overview

This repository provides comprehensive, flexible, and robust Terraform modules for managing OCI Always Free resources. All modules follow Terraform and OCI best practices, ensuring production-ready infrastructure as code.

## Modules

### Infrastructure

- **VCN**: Complete Virtual Cloud Network setup with public, private, and database subnets, Internet Gateway, NAT Gateway, Service Gateway, route tables, and security lists
- **Compute**: Always Free compute instances (VM.Standard.E2.1.Micro and VM.Standard.A1.Flex) with boot volumes, block volumes, and network configuration
- **Block Storage**: Block volumes with backup policies and attachments
- **Object Storage**: Object Storage buckets with lifecycle policies and pre-authenticated requests
- **Load Balancer**: Flexible load balancer with backend sets, listeners, and SSL/TLS support

### Database

- **Autonomous Database**: Oracle Autonomous Database (ATP/ADW) with Always Free tier support
- **MySQL HeatWave**: MySQL HeatWave Database Service with single-node configuration

### Security & Management

- **Vault**: Vault service with key management and secrets management
- **Bastion**: Bastion service for secure SSH access to private resources
- **Monitoring**: Monitoring alarms and metrics
- **Notifications**: Notification Service topics and subscriptions
- **Email Delivery**: Email Delivery senders and suppressions
- **Logging**: Log groups and logs for centralized logging

## Always Free Resources

All modules are designed to work within OCI Always Free tier limits:

### Compute
- **VM.Standard.E2.1.Micro**: Up to 2 instances (AMD processor)
- **VM.Standard.A1.Flex**: Up to 4 OCPUs and 24 GB memory total (Arm processor)
- **Total Block Storage**: 200 GB (boot + block volumes combined)
- **Volume Backups**: 5 backups total

### Database
- **Autonomous Database**: 2 instances, 1 OCPU + 20 GB storage each
- **MySQL HeatWave**: 1 single-node system, 50 GB data + 50 GB backup

### Storage
- **Object Storage**: 20 GB (free tier accounts)
- **API Requests**: 50,000 requests per month

### Networking
- **VCN**: 2 VCNs per tenancy
- **Load Balancer**: 1 flexible load balancer, 10 Mbps bandwidth

### Security & Management
- **Vault**: Unlimited software master keys, 20 HSM master key versions, 150 secrets
- **Bastion**: Free for all accounts
- **Monitoring**: 500 million ingestion data points, 1 billion retrieval data points per month
- **Notifications**: 1 million HTTPS notifications, 1,000 email notifications per month
- **Email Delivery**: 3,000 emails per month
- **Logging**: Free for Always Free tier

## Quick Start

### 1. Configure Environment Variables

Copy and configure the environment variables file:

```bash
cp .env.sh.example .env.sh
chmod 600 .env.sh
# Edit .env.sh with your specific values
source .env.sh

# Validate your configuration
validate_oci_credentials
show_config
```

**Required Variables:**
- `OCI_TENANCY_OCID` - Your tenancy OCID
- `OCI_USER_OCID` - Your user OCID
- `OCI_FINGERPRINT` - API key fingerprint
- `OCI_PRIVATE_KEY_PATH` - Path to your private API key file
- `TF_VAR_compartment_id` - Compartment OCID for resources

**Optional Variables:**
- `OCI_REGION` - OCI region (default: us-ashburn-1)
- `TF_VAR_project` - Project name (default: oci-modules)
- `TF_VAR_environment` - Environment name (default: development)

### 2. Configure Terraform CLI (Optional)

Copy and configure the Terraform CLI configuration:

```bash
cp .terraformrc.example .terraformrc
# Edit .terraformrc if needed (usually defaults are fine)
```

The `.terraformrc` file configures:
- Provider installation methods
- Plugin cache directory
- Credentials helpers
- Checkpoint settings

### 3. Use Makefile (Recommended)

The project includes a comprehensive Makefile with common tasks:

```bash
# Show all available commands
make help

# Format all Terraform files
make fmt

# Validate all modules
make validate-modules

# Run linting
make lint

# Run security scans
make security

# Generate documentation
make docs
```

### 4. Use a Module

Navigate to a module's example directory or create your own:

```hcl
module "vcn" {
  source = "./vcn"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  vcn_display_name = "my-vcn"
  vcn_cidr_blocks  = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true

  public_subnets = {
    public-subnet-1 = {
      cidr_block          = "10.0.1.0/24"
      display_name        = "public-subnet-1"
      dns_label           = "public1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      security_list_ids   = null
    }
  }

  project     = "my-project"
  environment = "production"
}
```

### 5. Initialize and Apply

```bash
# Using Makefile
make init
make plan
make apply

# Or using Terraform directly
terraform init
terraform plan
terraform apply
```

## Prerequisites

- Terraform >= 1.14.2
- OCI Provider ~> 7.30
- OCI CLI configured with appropriate credentials
- OCI account with Always Free tier enabled

## Environment Variables

See `.env.sh.example` for all available environment variables.

Key variables:

- `OCI_REGION`: OCI region (must be your home region for Always Free)
- `OCI_TENANCY_OCID`: Your tenancy OCID
- `OCI_USER_OCID`: Your user OCID
- `OCI_FINGERPRINT`: API key fingerprint
- `OCI_PRIVATE_KEY_PATH`: Path to your private API key
- `TF_VAR_compartment_id`: Compartment OCID for resources
- `TF_VAR_project`: Project name
- `TF_VAR_environment`: Environment (development, testing, staging, production)

## Makefile Commands

### Formatting

- `make fmt` - Format all Terraform files
- `make fmt-check` - Check if files are formatted
- `make fmt-module MODULE=vpc` - Format a specific module
- `make fmt-example EXAMPLE=vpc/examples/basic` - Format a specific example

### Validation

- `make validate` - Validate all modules and examples
- `make validate-modules` - Validate all modules
- `make validate-examples` - Validate all examples
- `make validate-module MODULE=vpc` - Validate a specific module

### Linting

- `make lint` - Run tflint on all modules
- `make lint-module MODULE=vpc` - Lint a specific module

### Security

- `make security` - Run security scans (tfsec and checkov)
- `make tfsec` - Run tfsec security scanner
- `make checkov` - Run checkov security scanner

### Documentation

- `make docs` - Generate documentation for all modules
- `make docs-module MODULE=vpc` - Generate docs for a specific module

### Terraform Operations

- `make init` - Initialize Terraform in current directory
- `make plan` - Run terraform plan
- `make apply` - Run terraform apply (with confirmation)

### Cleanup

- `make clean` - Clean all Terraform files (.terraform, .tfstate, etc.)

### Information

- `make list-modules` - List all modules
- `make list-examples` - List all examples
- `make info` - Show project information
- `make check-versions` - Check tool versions

### CI/CD

- `make pre-commit` - Run pre-commit checks (fmt-check, validate-modules, lint)
- `make ci` - Run full CI checks (fmt-check, validate, lint, security)

### Tool Installation

- `make install-tools` - Install all recommended tools
- `make install-terraform-docs` - Install terraform-docs
- `make install-tflint` - Install tflint
- `make install-tfsec` - Install tfsec
- `make install-checkov` - Install checkov

For more details, run `make help`.

## Module Structure

Each module follows a consistent structure:

```
<module-name>/
  main.tf          # Main resource definitions
  variables.tf     # Input variables
  outputs.tf       # Output values
  versions.tf      # Provider requirements
  README.md        # Module documentation
```

## Best Practices

1. **Always Free Constraints**: All modules include validation to ensure resources stay within Always Free limits
2. **Home Region**: Always Free resources must be created in your home region
3. **Tagging**: All modules support comprehensive tagging for resource management
4. **Security**: Default security configurations follow OCI security best practices
5. **Modularity**: Modules are designed to be composable and reusable
6. **Documentation**: Each module includes comprehensive documentation and examples

## Examples

Each module includes example configurations. See the `examples/` directory (to be created) for complete working examples.

## Contributing

Contributions are welcome! Please ensure:

1. All code follows Terraform and OCI best practices
2. Modules include proper validation for Always Free limits
3. Documentation is updated
4. Examples are provided
5. Code is formatted and validated

## License

This project is licensed under the Apache License 2.0. See LICENSE for details.

## References

- [OCI Always Free Resources Documentation](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
- [Terraform OCI Provider Documentation](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Best Practices](https://docs.oracle.com/en-us/iaas/Content/terraform/best-practices.htm)
