# Terragrunt Configuration for OCI Always Free Modules

This directory provides a production-ready [Terragrunt](https://terragrunt.gruntwork.io/) wrapper around all 13 OCI Terraform modules. It handles remote state, provider configuration, cross-module dependencies, and environment promotion.

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) | `>= 0.55` |
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | `>= 1.14.2` |
| OCI CLI (for `oci setup config`) | `>= 3.x` |

## Directory Structure

```
terragrunt/
├── terragrunt.hcl                 # Root: remote state (OCI Object Storage) + provider generation + shared inputs
├── _envcommon/                    # Per-module shared configs (DRY defaults); see _envcommon/README.md
│   ├── vcn.hcl
│   ├── compute.hcl
│   ├── autonomous-database.hcl
│   ├── block-storage.hcl
│   ├── object-storage.hcl
│   ├── load-balancer.hcl
│   ├── bastion.hcl
│   ├── vault.hcl
│   ├── monitoring.hcl
│   ├── notifications.hcl
│   ├── logging.hcl
│   ├── email-delivery.hcl
│   └── mysql.hcl
└── environments/
    ├── development/               # Always Free dev environment (see development/README.md)
    │   ├── env.hcl                # Region, environment name, project
    │   ├── vcn/terragrunt.hcl
    │   ├── compute/terragrunt.hcl
    │   ├── autonomous-database/terragrunt.hcl
    │   ├── block-storage/terragrunt.hcl
    │   ├── object-storage/terragrunt.hcl
    │   ├── load-balancer/terragrunt.hcl
    │   ├── bastion/terragrunt.hcl
    │   ├── vault/terragrunt.hcl
    │   ├── monitoring/terragrunt.hcl
    │   ├── notifications/terragrunt.hcl
    │   ├── logging/terragrunt.hcl
    │   ├── email-delivery/terragrunt.hcl
    │   └── mysql/terragrunt.hcl
    └── production/                # Prod environment (see production/README.md)
        ├── env.hcl
        └── ... (same 13 modules)
```

## Configuration Layers

Each child `terragrunt.hcl` merges three layers (deepest wins):

```
Root terragrunt.hcl          → provider_tg.tf + backend.tf + project/environment + default freeform_tags
  └─ _envcommon/<module>.hcl → terraform.source + Always Free defaults + compartment_id
       └─ environments/<env>/<module>/terragrunt.hcl → env-specific overrides + dependencies
```

The root `inputs` block sets `project`, `environment`, and a baseline `freeform_tags` map (`Project`, `Environment`, `ManagedBy`) so leaf stacks and modules stay consistent without repeating tags in every `_envcommon` file. Override or extend tags in an environment’s `terragrunt.hcl` when needed (deep merge).

`environments/<env>/env.hcl` supplies `region`, `project`, `environment`, and optional `ad_index`. The object-storage stack uses `local.region` from `_envcommon` so it stays aligned with the provider region.

## Quick Start

### 1. OCI Authentication

**Option A — Config file (recommended):**
```bash
oci setup config      # creates ~/.oci/config with [DEFAULT] profile
```

**Option B — Environment variables:**
```bash
export OCI_CLI_TENANCY=ocid1.tenancy.oc1..xxxx
export OCI_CLI_USER=ocid1.user.oc1..xxxx
export OCI_CLI_FINGERPRINT=xx:xx:xx:...
export OCI_CLI_KEY_FILE=~/.oci/oci_api_key.pem
```

### 2. Module Source (Copy-Paste Ready)

`_envcommon/*.hcl` sets an explicit remote module source, for example:

```hcl
terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//vcn"
}
```

You can copy stacks into another repo without editing the URL. Pin a branch or tag with a query string if needed, e.g. `...git?ref=v1.0.0//vcn`.

For **local development** (iterate on a clone without pushing), override `terraform.source` in the leaf `environments/<env>/<module>/terragrunt.hcl` (merged after `_envcommon`, so it wins):

```hcl
terraform {
  source = "/path/to/terraform-oci-modules//vcn"
}
```

### 3. Set Required Environment Variables

```bash
# Required for all modules
export TF_VAR_compartment_id=ocid1.compartment.oc1..xxxx
export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..xxxx

# Required for stacks that use subnets or AD-specific resources (VCN, compute, MySQL, load balancer, bastion, block-storage volumes)
export TF_VAR_availability_domain="oci-yourdomain-ad-1"

# Optional: standalone Terraform examples only; Terragrunt object-storage uses region from env.hcl
export TF_VAR_region=ap-seoul-1        # should match environments/*/env.hcl

# Compute
export TF_VAR_ssh_public_keys="$(cat ~/.ssh/id_rsa.pub)"

# Databases — set at runtime from a secret manager or CI (never commit real values):
#   export TF_VAR_adb_admin_password="..."
#   export TF_VAR_mysql_admin_password="..."
# Or: read -s TF_VAR_adb_admin_password; export TF_VAR_adb_admin_password

# Notifications
export TF_VAR_alert_email="ops@example.com"

# Email delivery sender
export TF_VAR_sender_email="noreply@yourdomain.com"

# Bastion (restrict to your IP in production)
export TF_VAR_bastion_allowed_cidr="0.0.0.0/0"
```

**Always Free development (minimal checklist):** set compartment/tenancy, **`TF_VAR_availability_domain`**, remote-state credentials, then SSH and DB passwords before those stacks. See [environments/development/README.md](environments/development/README.md).

### 4. Remote State (OCI Object Storage via S3-compatible API)

```bash
# 1. Create a Customer Secret Key in OCI Console:
#    Identity → Users → <your user> → Customer Secret Keys → Generate Secret Key
export AWS_ACCESS_KEY_ID=<customer-secret-key-id>
export AWS_SECRET_ACCESS_KEY=<customer-secret-key-secret>

# 2. Set your Object Storage namespace
export TG_OCI_NAMESPACE=$(oci os ns get --query 'data' --raw-output)

# 3. Create the state bucket (first time only)
oci os bucket create \
  --compartment-id "${TF_VAR_compartment_id}" \
  --name "terragrunt-state-oci-modules-development" \
  --versioning Enabled
```

### 5. Edit env.hcl

Update `environments/development/env.hcl` (and `production/env.hcl`) with your region:

```hcl
locals {
  environment = "development"
  region      = "ap-seoul-1"   # ← Your OCI home region
  project     = "oci-modules"
}
```

### 6. Deploy

```bash
cd environments/development

# Deploy everything in dependency order
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply

# Or deploy a single module
cd vcn
terragrunt init
terragrunt plan
terragrunt apply
```

## Module Dependency Graph

```
vcn ──────────┬──→ compute ──→ block-storage
              ├──→ load-balancer
              ├──→ bastion
              └──→ mysql

notifications ──→ monitoring

# Independent (no dependencies):
autonomous-database
object-storage
vault
logging
email-delivery
```

## Always Free Tier Limits

All modules enforce Always Free constraints via Terraform `validation` blocks:

| Module | Always Free Limit |
|--------|------------------|
| `compute` | 2× VM.Standard.E2.1.Micro **or** 4 OCPU + 24 GB VM.Standard.A1.Flex |
| `block-storage` | 200 GB total (boot + data volumes) |
| `object-storage` | 20 GB |
| `autonomous-database` | 2× instances, 1 OCPU + 20 GB each |
| `mysql` | 1× single-node, 50 GB data + 50 GB backup |
| `load-balancer` | 1× flexible, 10 Mbps min/max bandwidth |
| `vault` | DEFAULT type (software keys — unlimited) |
| `bastion` | Free for all account types |
| `monitoring` | 500 M ingestion points/month |
| `notifications` | 1 M HTTPS + 1,000 email/month |
| `email-delivery` | 3,000 emails/month |
| `logging` | Free for Always Free tier |

## Common Terragrunt Commands

```bash
# Validate all modules (uses mock outputs, no OCI calls)
terragrunt run-all validate --terragrunt-ignore-external-dependencies

# Plan everything
terragrunt run-all plan

# Apply with auto-approval (CI use)
terragrunt run-all apply --terragrunt-non-interactive

# Destroy everything (reverse order)
terragrunt run-all destroy

# Show dependency graph
terragrunt graph-dependencies | dot -Tpng > deps.png

# Target a single module
cd environments/development/compute && terragrunt apply

# Force re-init (after provider version changes)
terragrunt run-all init --upgrade
```

## Switching to ARM (VM.Standard.A1.Flex)

Edit `environments/<env>/compute/terragrunt.hcl`:

```hcl
inputs = {
  shape         = "VM.Standard.A1.Flex"
  instance_count = 1      # up to 4 OCPUs total across all instances
  ocpus         = 4
  memory_in_gbs = 24
  subnet_id     = dependency.vcn.outputs.public_subnet_ids["public-1"]
  ssh_public_keys = get_env("TF_VAR_ssh_public_keys", "")
}
```

## Security Notes

- **Passwords** (`adb_admin_password`, `mysql_admin_password`) are passed via `TF_VAR_*` env vars and never stored in `.hcl` files or state in plain text by the modules.
- **SSH keys** are passed via env var, not committed to source control.
- **OCI API key** stays in `~/.oci/` and is never referenced in Terraform code (provider reads it automatically).
- **State bucket** should have versioning enabled and access restricted to your IAM group.
- **Bastion** `client_cidr_block_allow_list` should be restricted to known IPs in production.

## Troubleshooting

| Error | Fix |
|-------|-----|
| `Error: No valid credential sources found` | Run `oci setup config` or set `OCI_CLI_*` env vars |
| `Error: failed to get object storage namespace` | Set `TG_OCI_NAMESPACE` env var |
| `Error: compartment_id is required` | Set `TF_VAR_compartment_id` env var |
| `Error accessing state bucket` | Create the bucket or check `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` |
| `mock_outputs not matching` | Normal for `plan` — mock outputs are used when dependency hasn't been applied yet |
| `availability_domain not set` | Set `TF_VAR_availability_domain` to your AD name (e.g., `oci-yourdomain-ad-1`) |

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [OCI Terraform Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
- [OCI Object Storage S3 Compatibility](https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/s3compatibleapi.htm)
