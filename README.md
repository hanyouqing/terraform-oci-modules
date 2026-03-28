# Terraform OCI Modules

A collection of production-ready Terraform modules for Oracle Cloud Infrastructure (OCI).

## Overview

This repository provides comprehensive, flexible, and robust Terraform modules for managing OCI. All modules follow Terraform and OCI best practices, ensuring production-ready infrastructure as code.

For **Terragrunt** (remote state, generated provider, DRY stack configs), see [terragrunt/README.md](terragrunt/README.md) and the [Always Free development checklist](terragrunt/environments/development/README.md).

## Modules

### Infrastructure

- **VCN**: Complete Virtual Cloud Network setup with public, private, and database subnets, Internet Gateway, NAT Gateway, Service Gateway, route tables, and security lists
- **Compute**: Always Free compute instances (VM.Standard.E2.1.Micro and VM.Standard.A1.Flex) with boot volumes, block volumes, and network configuration
- **Block Storage**: Block volumes with backup policies and attachments
- **Object Storage**: Object Storage buckets with lifecycle policies and pre-authenticated requests
- **Load Balancer**: Flexible load balancer with backend sets, listeners, and SSL/TLS support
- **Network Load Balancer**: Layer 4 (TCP/UDP) network load balancer with backend sets, listeners, and health checks
- **Site-to-Site VPN**: IPSec VPN connections with CPE objects and redundant tunnels

### Database

- **Autonomous Database**: Oracle Autonomous Database (ATP/ADW) with Always Free tier support
- **MySQL HeatWave**: MySQL HeatWave Database Service with single-node configuration
- **NoSQL Database**: NoSQL Database tables with secondary indexes and Always Free tier support

### Security & Management

- **Vault**: Vault service with key management and secrets management
- **Certificates**: Certificate Authorities and TLS certificates with Always Free tier support
- **Bastion**: Bastion service for secure SSH access to private resources
- **Monitoring**: Monitoring alarms and metrics
- **Notifications**: Notification Service topics and subscriptions
- **Email Delivery**: Email Delivery senders and suppressions
- **Logging**: Log groups and logs for centralized logging
- **APM**: Application Performance Monitoring domains and Synthetics monitors
- **Credentials**: IAM credentials (API keys, auth tokens, customer secret keys, SMTP credentials)

## Always Free Resources (Demo Deployment Order)

Deploy in this order for a demo project. All resources must be created in your **home region**.

| # | Resource | Limit | Module |
|---|----------|-------|--------|
| 1 | **VCN** (Virtual Cloud Network) | 2 per tenancy | vcn |
| 2 | **Certificates** | 5 CAs, 150 certificates | certificates |
| 3 | **Vault** | Unlimited software keys, 20 HSM key versions, 150 secrets | vault |
| 4 | **Compute** (VM.Standard.E2.1.Micro) | 2 instances (1/8 OCPU, 1 GB RAM each) | compute |
| 5 | **Compute** (VM.Standard.A1.Flex) | 4 OCPUs + 24 GB RAM total (Arm) | compute |
| 6 | **Block Volume** | 200 GB total (boot + block), 5 backups | block-storage |
| 7 | **Object Storage** | 20 GB | object-storage |
| 8 | **Autonomous Database** | 2 instances (1 OCPU + 20 GB each) | autonomous-database |
| 9 | **MySQL HeatWave** | 1 node, 50 GB data + 50 GB backup | mysql |
| 10 | **NoSQL Database** | 3 tables, 25 GB/table, 133M reads/writes/month | nosql-database |
| 11 | **Load Balancer** (Flexible) | 1 instance, 10 Mbps | load-balancer |
| 12 | **Network Load Balancer** | 1 instance | network-load-balancer |
| 13 | **Bastion** | Free for all accounts | bastion |
| 14 | **Monitoring** | 500M ingestion + 1B retrieval points/month | monitoring |
| 15 | **Logging** | 10 GB/month (VCN flow logs) | logging |
| 16 | **Notifications** | 1M HTTPS + 1K email/month | notifications |
| 17 | **Email Delivery** | 3,000 emails/month | email-delivery |
| 18 | **APM** | 1K tracing events, 10 synthetic runs/hour | apm |
| 19 | **Outbound Data Transfer** | 10 TB/month | — |
| 20 | **Site-to-Site VPN** | 50 IPSec connections | site-to-site-vpn |

**Best practices for demo projects:**
1. Create VCN first (foundation for all networking)
2. Use Bastion for SSH access to private instances (avoid public IPs)
3. Stay within home region—Always Free is not available in other regions
4. Use compartment quotas to cap usage
5. Idle A1 instances may be reclaimed after 7 days of under 20% CPU/memory/network utilization

## Configuration Files

This project includes configuration files for development tools:

- **`.tflint.hcl`** - TFLint configuration for Terraform linting
- **`.tfsec.yml`** - TFSec configuration for security scanning
- **`.terraform-docs.yml`** - Terraform-docs configuration for documentation generation
- **`.env.sh.example`** - Environment variables template (single default file: `.env.sh`)
- **`credentials/example.env.example`** - Per-account env template (see [Multiple OCI accounts](#multiple-oci-accounts))
- **`scripts/oci-use.sh`** - Switch account by name: `eval "$(./scripts/oci-use.sh <account>)"` or `source` + `oci_use <account>`
- **`.terraformrc`** - Terraform CLI configuration (provider install, plugin cache)

See [docs/CONFIG.md](docs/CONFIG.md) for detailed configuration guide.

## Setting up OCI credentials for the Terraform provider

The [Oracle Cloud Infrastructure Terraform provider](https://registry.terraform.io/providers/oracle/oci/latest/docs) must authenticate before it can manage resources. The authoritative guide is Oracle’s [Configuring the Provider](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm), which describes authentication options, environment variables, the shared `~/.oci/config` file, and **order of precedence** when values are set in more than one place.

### Supported authentication methods

Per the official documentation, the provider supports:

| Method | Typical use |
| --- | --- |
| **API key** (default) | Local development, workstations, automation with stored secrets |
| **Instance principal** | Terraform running on OCI Compute (`auth = "InstancePrincipal"`) |
| **Resource principal** | Functions and similar (`auth = "ResourcePrincipal"` + env vars) |
| **Security token** | Short-lived CLI tokens (`auth = "SecurityToken"`; token expires, often ~1 hour) |
| **OKE workload identity** | Workloads on Oracle Kubernetes Engine (`auth = "OKEWorkloadIdentity"`) |

This repository’s `.env.sh.example` workflow uses **API key authentication**, which is the default when `auth` is not set to another mode.

### API key authentication (recommended for local use)

1. **Create an API signing key pair** in PEM format and **upload the public key** to your OCI user. Oracle documents this in [Required Keys and OCIDs](https://docs.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm) (generate key, upload public key, fingerprint).
2. **Collect identifiers**: tenancy OCID, user OCID, key fingerprint, and region. The same doc explains where to find tenancy and user OCIDs.
3. **Provide credentials to Terraform** using one or both of the following (do not commit secrets):

**Environment variables** — Oracle documents equivalent names; either the `OCI_*` form or the `TF_VAR_*` form can be used for the provider arguments (see [Environment variables](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm) in *Configuring the Provider*). This project’s template uses the `OCI_*` names for clarity:

| Variable | Purpose |
| --- | --- |
| `OCI_TENANCY_OCID` | Tenancy OCID |
| `OCI_USER_OCID` | User OCID |
| `OCI_FINGERPRINT` | API key fingerprint |
| `OCI_PRIVATE_KEY_PATH` | Path to the private key `.pem` file |
| `OCI_REGION` | Region identifier (defaults to `ap-seoul-1` in this repo’s templates) |
| `TF_VAR_home_region` | Home region for tagging / Always Free (defaults to `OCI_REGION` or `ap-seoul-1`) |
| `OCI_PRIVATE_KEY_PASSWORD` | Only if the private key is encrypted |

Optional: `OCI_PRIVATE_KEY` (key material inline) takes precedence over `OCI_PRIVATE_KEY_PATH` when both are set—prefer a file path with restricted permissions for interactive use.

**Shared config file** — You can store the same values in `~/.oci/config` (same file as the OCI CLI and SDKs). See [SDK and CLI Configuration File](https://docs.oracle.com/iaas/Content/API/Concepts/sdkconfig.htm). To select a non-default profile, set `OCI_CONFIG_FILE_PROFILE` or `TF_VAR_config_file_profile`. If parameters are set in multiple places, Oracle’s documented precedence is: **environment variables**, then **non-default profile** (if used), then the **`DEFAULT`** profile in `~/.oci/config`.

### Setting up credentials with the OCI CLI

The [OCI Command Line Interface](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) can create and update the same `~/.oci/config` file Terraform uses, so you do not have to hand-edit paths and OCIDs. The standard entry point is **`oci setup config`** (see [Configuring the CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliconfigure.htm)).

1. **Install** the OCI CLI for your OS ([installation guide](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)).
2. **Run the interactive setup** ([configuring the CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliconfigure.htm)):
   ```bash
   oci setup config
   ```
   You will be prompted for:
   - Location of the config file (default: `~/.oci/config`)
   - **User OCID** and **tenancy OCID**
   - **Region** (e.g. `ap-seoul-1`)
   - Whether to **generate a new API key** or use an existing private key path
   - Optional **passphrase** if the key is encrypted  
   If the wizard generates a new key pair, **add the public key** to your user in the OCI Console (Identity → Users → your user → API keys), same as the manual flow in [Required Keys and OCIDs](https://docs.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm).
3. **Verify** the CLI can authenticate:
   ```bash
   oci iam region list --output table
   oci os ns get
   ```
4. **Use with Terraform**: With no conflicting `OCI_TENANCY_OCID` / `OCI_USER_OCID` / … exports in your shell, the provider can use the **`DEFAULT`** profile from `~/.oci/config`. If you use `.env.sh` from this repo, either omit those `OCI_*` lines or comment them out so the file does not override the CLI config. Set **`OCI_REGION`** (or `region` in the profile) to match the region you chose in step 2.

**CLI profile vs Terraform profile**

| Goal | What to set |
| --- | --- |
| Use a named profile with the **`oci`** command | `oci ... --profile MYPROFILE` or `export OCI_CLI_PROFILE=MYPROFILE` |
| Use the same named profile with **Terraform** | `export OCI_CONFIG_FILE_PROFILE=MYPROFILE` (or `TF_VAR_config_file_profile`) |

Add extra profiles by running `oci setup config` again and choosing another profile name, or by editing `~/.oci/config` following Oracle’s [configuration file format](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm). See also [Multiple OCI accounts](#multiple-oci-accounts).

### Best practices

- **Never commit** private keys, `.env.sh`, or Terraform files containing raw credentials. Keep `.env.sh` mode `600` and restrict access to key files (see `.env.sh.example`).
- **Prefer environment variables or a secured config file** over hard-coding credentials in `provider "oci"` blocks; align with [Authoring Configurations](https://docs.oracle.com/iaas/Content/dev/terraform/authoring-configs.htm) and your org’s secret store for CI/CD.
- **Use least-privilege IAM** in OCI: scope API keys and policies to the compartment and actions Terraform needs.
- **Session / token auth**: Security token auth can expire mid-run; avoid it for long `apply` operations unless you refresh tokens as documented.
- **In-OCI automation**: Prefer **instance principal** or **resource principal** over embedding long-lived API keys on instances or in function images.

For Terraform-specific OCI guidance, see also [OCI Terraform best practices](https://docs.oracle.com/en-us/iaas/Content/terraform/best-practices.htm).

### Multiple OCI accounts

Use one **account** (tenancy + user API key + compartment) per logical context—e.g. personal vs work, or separate tenancies. Two complementary patterns work well with the OCI Terraform provider:

```mermaid
flowchart LR
  subgraph optA["Option A — ~/.oci/config profiles"]
    P1[profile A]
    P2[profile B]
    CFG["~/.oci/config"]
    P1 --> CFG
    P2 --> CFG
    E1["OCI_CONFIG_FILE_PROFILE"]
    CFG --> E1
  end
  subgraph optB["Option B — repo credential bundles"]
    F1["credentials/ACI_ACCOUNT_NAME.env"]
    F2["credentials/work.env"]
    OU["eval \"\$(./scripts/oci-use.sh ACI_ACCOUNT_NAME)\""]
    F1 --> OU
    F2 --> OU
    OU --> ENV["OCI_* and TF_VAR_* in shell"]
  end
```

**Option A — OCI shared config profiles (CLI/SDK standard)**  
Put each account in a separate `[PROFILE]` section in [`~/.oci/config`](https://docs.oracle.com/iaas/Content/API/Concepts/sdkconfig.htm). Switch the active profile for Terraform and the CLI by exporting:

```bash
export OCI_CONFIG_FILE_PROFILE=WORK   # or TF_VAR_config_file_profile
# Optional: point Terraform at a non-default config path
# export OCI_CLI_CONFIG_FILE=/path/to/config
```

Unset explicit `OCI_TENANCY_OCID`, `OCI_USER_OCID`, etc. if you want the profile to supply them; per Oracle’s [order of precedence](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm), **environment variables override** profile values—so clear env vars when switching profile-only mode, or keep using profiles consistently.

**Option B — Named env files in this repo (explicit switching)**  
Keep one file per account under `credentials/` (gitignored `*.env`). Copy `credentials/example.env.example` to e.g. `credentials/ACI_ACCOUNT_NAME.env`, fill in OCIDs, key path, and `TF_VAR_compartment_id`. The **account name** is the file basename without `.env` (here `ACI_ACCOUNT_NAME` is a placeholder—use your own short name).

Switch the active account in your shell (bash):

```bash
# Recommended: pass account name to the script, apply exports in this shell
eval "$(./scripts/oci-use.sh ACI_ACCOUNT_NAME)"

./scripts/oci-use.sh list          # list account names
validate_oci_credentials
```

Alternative — define helpers then call by name:

```bash
source scripts/oci-use.sh
oci_use_list
oci_use ACI_ACCOUNT_NAME
echo "$OCI_ACTIVE_CREDENTIAL_PROFILE"   # ACI_ACCOUNT_NAME
```

`oci_use` / `eval "$(./scripts/oci-use.sh …)"` clear common tenant-specific variables before loading the next file so a switch does not leak values from the previous account. Override the directory with `OCI_CREDENTIALS_DIR` if you store bundles outside the repo.

**Combining A and B**  
You can set `OCI_CONFIG_FILE_PROFILE` inside a `credentials/<name>.env` file for an account that uses a profile name plus extra Terraform variables (e.g. compartment).

**CI/CD**  
Prefer OIDC or vault-injected short-lived credentials per pipeline; avoid long-lived API keys in job logs. For runners **inside** OCI, use instance or resource principals instead of key files.

## Quick Start

### 1. Configure environment variables

**Single account:** copy the template, fill in values from the [API key](#api-key-authentication-recommended-for-local-use) steps above, then validate:

```bash
cp .env.sh.example .env.sh
chmod 600 .env.sh
# Edit .env.sh with your specific values
source .env.sh

# Validate your configuration
validate_oci_credentials
show_config
```

**Multiple accounts:** use [`~/.oci/config` profiles](#multiple-oci-accounts) and `OCI_CONFIG_FILE_PROFILE`, or [named files under `credentials/`](#multiple-oci-accounts) with `scripts/oci-use.sh`.

**Required variables:**

- `OCI_TENANCY_OCID` — Tenancy OCID
- `OCI_USER_OCID` — User OCID
- `OCI_FINGERPRINT` — API key fingerprint
- `OCI_PRIVATE_KEY_PATH` — Path to your private API key file
- `TF_VAR_compartment_id` — Compartment OCID for resources

**Optional variables:**

- `OCI_REGION` — OCI region (default: ap-seoul-1)
- `TF_VAR_home_region` — Home region for modules that use it (default: `OCI_REGION` or `ap-seoul-1`)
- `TF_VAR_project` — Project name (default: oci-modules)
- `TF_VAR_environment` — Environment name (default: development)

### 2. Configure Terraform CLI (Optional)

Use the project's Terraform config:

```bash
export TF_CLI_CONFIG_FILE="$(pwd)/.terraformrc"
```

Or copy to your home directory for global use: `cp .terraformrc ~/.terraformrc`

The `.terraformrc` file configures:
- Provider installation (direct from registry)
- Plugin cache directory

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
- [OCI credentials](#setting-up-oci-credentials-for-the-terraform-provider) for the Terraform provider — the [OCI CLI](#setting-up-credentials-with-the-oci-cli) (`oci setup config`) is the usual way to create `~/.oci/config`; alternatively use environment variables from `.env.sh` only
- OCI account with Always Free tier enabled

## Environment Variables

See `.env.sh.example` for all available environment variables. Credential names and precedence are described in [Setting up OCI credentials](#setting-up-oci-credentials-for-the-terraform-provider).

Key variables:

- `OCI_REGION`: OCI region (defaults to `ap-seoul-1` in templates; must be your real home region for Always Free)
- `TF_VAR_home_region`: Home region passed to Terraform (defaults to `OCI_REGION` or `ap-seoul-1`)
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
- `make fmt-module MODULE=vcn` - Format a specific module
- `make fmt-example EXAMPLE=vcn/examples/basic` - Format a specific example

### Validation

- `make validate` — runs `terraform init -backend=false` and `terraform validate` for each top-level module (with `main.tf`) and each `*/examples/*` Terraform root. Creates `~/.terraform.d/plugin-cache` first (`validate-prep`) so a `plugin_cache_dir` in `.terraformrc` does not break init. Use `export TF_CLI_CONFIG_FILE=/path/to/repo/.terraformrc` if your Terraform CLI config lives in this repo.
- `make validate-modules` — modules only
- `make validate-examples` — examples only (examples call the parent module via `source = "../../"` so validation uses the **local** copy; pin `git::https://github.com/hanyouqing/terraform-oci-modules.git//<module>?ref=…` when copying examples into another repo)

### Linting

- `make lint` - Run tflint on all modules (uses `.tflint.hcl` config)
- `make lint-init` - Initialize tflint plugins
- `make lint-module MODULE=vcn` - Lint a specific module

**Configuration:** `.tflint.hcl` - Configure tflint rules and plugins

### Security

- `make security` - Run security scans (tfsec and checkov)
- `make tfsec` - Run tfsec security scanner (uses `.tfsec.yml` config)
- `make checkov` - Run checkov security scanner

**Configuration:** `.tfsec.yml` - Configure tfsec exclusions and severity levels

### Documentation

- `make docs` - Generate documentation for all modules (uses `.terraform-docs.yml` config)
- `make docs-module MODULE=vcn` - Generate docs for a specific module

**Configuration:** `.terraform-docs.yml` - Configure terraform-docs output format and content

### Terraform Operations

- `make init` - Initialize Terraform in current directory
- `make plan` - Run terraform plan
- `make apply` - Run terraform apply (with confirmation)

### Workspace Management

- `make workspace ENV=production` - Switch to or create a workspace (development, testing, staging, production)
- `make workspace-list` - List all workspaces
- `make workspace-show` - Show current workspace
- `make plan-workspace ENV=production` - Run terraform plan with workspace
- `make apply-workspace ENV=production` - Run terraform apply with workspace

**Alternative Usage:**
```bash
# Using wrapper script
./terraform-wrapper.sh -e production plan
./terraform-wrapper.sh -e production apply

# Using workspace script directly
./scripts/terraform-workspace.sh -e production
```

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
4. **Security**: Default security configurations follow OCI security best practices; see [docs/SECURITY.md](docs/SECURITY.md) for secrets, env vars, and state handling
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

- [Security practices (secrets, state, env)](docs/SECURITY.md)
- [OCI Always Free Resources Documentation](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
- [Configuring the OCI Terraform Provider](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm) (authentication, environment variables, `~/.oci/config`)
- [OCI CLI installation](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) and [configuring the CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliconfigure.htm) (`oci setup config`)
- [Terraform OCI Provider Documentation](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Best Practices](https://docs.oracle.com/en-us/iaas/Content/terraform/best-practices.htm)
