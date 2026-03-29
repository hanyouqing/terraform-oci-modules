# Terragrunt Configuration for OCI Modules

Production-ready [Terragrunt](https://terragrunt.gruntwork.io/) wrapper for all 19 OCI Terraform modules. Supports **multi-account**, **multi-region**, and **multi-environment** deployments with isolated state, provider configuration, cross-module dependencies, and environment promotion.

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) | `>= 0.55` |
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | `>= 1.14.2` |
| OCI CLI (for `oci setup config`) | `>= 3.x` |

## Directory Structure

The layout follows a **3-layer hierarchy**: Account → Region → Environment.

```
terragrunt/
├── terragrunt.hcl                 # Root config: remote state, provider gen, shared inputs
├── _envcommon/                    # Per-module shared defaults (19 modules); see _envcommon/README.md
│   ├── vcn.hcl
│   ├── compute.hcl
│   ├── bastion.hcl
│   ├── block-storage.hcl
│   ├── object-storage.hcl
│   ├── load-balancer.hcl
│   ├── network-load-balancer.hcl
│   ├── autonomous-database.hcl
│   ├── mysql.hcl
│   ├── nosql-database.hcl
│   ├── vault.hcl
│   ├── certificates.hcl
│   ├── credentials.hcl
│   ├── monitoring.hcl
│   ├── notifications.hcl
│   ├── logging.hcl
│   ├── email-delivery.hcl
│   ├── apm.hcl
│   └── site-to-site-vpn.hcl
│
├── personal/                      # ← Account (OCI tenancy)
│   ├── account.hcl                # tenancy_ocid, compartment_id, namespace, OCI CLI profile
│   │
│   ├── ap-seoul-1/                # ← Region
│   │   ├── region.hcl             # region = "ap-seoul-1"
│   │   ├── development/           # ← Environment
│   │   │   ├── env.hcl            # environment, project, ad_index
│   │   │   ├── vcn/terragrunt.hcl
│   │   │   ├── compute/terragrunt.hcl
│   │   │   └── ... (19 modules)
│   │   └── production/
│   │       ├── env.hcl
│   │       └── ... (19 modules)
│   │
│   └── us-ashburn-1/              # ← Second region (same account)
│       ├── region.hcl
│       └── development/
│           ├── env.hcl
│           └── ... (subset of modules)
│
└── company/                       # ← Second account (example)
    ├── account.hcl
    └── us-phoenix-1/
        └── production/
            └── ...
```

### Adding a new account, region, or environment

| Want to add | What to create |
|-------------|---------------|
| **Account** | New directory under `terragrunt/`, copy `account.hcl` template |
| **Region** | New directory under `<account>/`, create `region.hcl` with one local |
| **Environment** | New directory under `<account>/<region>/`, create `env.hcl`, copy module dirs |

## Configuration Layers

Each leaf `terragrunt.hcl` resolves four config layers (deepest wins):

```
Root terragrunt.hcl                           → provider_tg.tf + backend.tf + shared inputs
  └─ <account>/account.hcl                    → tenancy_ocid, compartment_id, namespace, profile
      └─ <account>/<region>/region.hcl        → region
          └─ _envcommon/<module>.hcl           → terraform.source + module defaults
              └─ <account>/<region>/<env>/<module>/terragrunt.hcl → env-specific overrides + dependencies
```

**Root `terragrunt.hcl`** provides:
- Remote state (OCI Object Storage via S3-compatible API)
- Provider generation (`provider_tg.tf`) with region and OCI profile from `account.hcl`
- Shared inputs: `project`, `environment`, `compartment_id`, `tenancy_ocid`, `freeform_tags`

**Shared inputs (`freeform_tags`)** include `Project`, `Environment`, `Account`, `Region`, and `ManagedBy` for cost attribution and resource discovery.

## Quick Start

### 1. OCI Authentication

Create a profile in `~/.oci/config` for each OCI account:

```ini
[DEFAULT]
tenancy=ocid1.tenancy.oc1..xxxx
user=ocid1.user.oc1..xxxx
fingerprint=xx:xx:xx:...
key_file=~/.oci/oci_api_key.pem
region=ap-seoul-1

[company]
tenancy=ocid1.tenancy.oc1..yyyy
user=ocid1.user.oc1..yyyy
fingerprint=yy:yy:yy:...
key_file=~/.oci/company_api_key.pem
region=us-phoenix-1
```

The `config_file_profile` in `account.hcl` selects which profile to use.

### 2. Configure account.hcl

```hcl
# terragrunt/personal/account.hcl
locals {
  account_name        = "personal"
  tenancy_ocid        = "ocid1.tenancy.oc1..xxxx"
  compartment_id      = "ocid1.compartment.oc1..xxxx"
  namespace           = "your-namespace"        # oci os ns get
  config_file_profile = "DEFAULT"               # matches ~/.oci/config profile
}
```

### 3. Configure region.hcl

```hcl
# terragrunt/personal/ap-seoul-1/region.hcl
locals {
  region = "ap-seoul-1"
}
```

### 4. Configure env.hcl

```hcl
# terragrunt/personal/ap-seoul-1/development/env.hcl
locals {
  environment = "development"
  project     = "oci-modules"
  ad_index    = 0                # availability domain index
}
```

### 5. Remote State (OCI Object Storage via S3-compatible API)

```bash
# 1. Create a Customer Secret Key in OCI Console:
#    Identity → Users → <your user> → Customer Secret Keys → Generate Secret Key
export AWS_ACCESS_KEY_ID=<customer-secret-key-id>
export AWS_SECRET_ACCESS_KEY=<customer-secret-key-secret>

# 2. Create the state bucket (first time only)
#    Bucket name format: tfstate-<account_name>-<project>
oci os bucket create \
  --compartment-id "ocid1.compartment.oc1..xxxx" \
  --name "tfstate-personal-oci-modules" \
  --versioning Enabled
```

State key layout: `<region>/<environment>/<module>/terraform.tfstate` — state is fully isolated across accounts, regions, and environments.

### 6. Set Runtime Environment Variables

```bash
# Required for AD-specific resources (compute, block-storage, MySQL, bastion)
export TF_VAR_availability_domain="oci-yourdomain-ad-1"

# Compute
export TF_VAR_ssh_public_keys="$(cat ~/.ssh/id_rsa.pub)"

# Databases — set from secret manager or read interactively (never commit values)
read -s TF_VAR_adb_admin_password && export TF_VAR_adb_admin_password
read -s TF_VAR_mysql_admin_password && export TF_VAR_mysql_admin_password

# Notifications
export TF_VAR_alert_email="ops@example.com"

# Email delivery
export TF_VAR_sender_email="noreply@yourdomain.com"

# Bastion (restrict to your IP in production)
export TF_VAR_bastion_allowed_cidr="0.0.0.0/0"
```

### 7. Deploy

```bash
cd terragrunt/personal/ap-seoul-1/development

# Deploy everything in dependency order
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply

# Deploy a single module
cd vcn
terragrunt init && terragrunt plan && terragrunt apply
```

## Module Source

`_envcommon/*.hcl` uses remote Git module sources:

```hcl
terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//vcn"
}
```

Pin a version: `...git?ref=v1.0.0//vcn`

For **local development**, override in the leaf `terragrunt.hcl`:

```hcl
terraform {
  source = "/path/to/terraform-oci-modules//vcn"
}
```

## Module Dependency Graph

```
vcn ──────────┬──→ compute ──→ block-storage
              ├──→ load-balancer
              ├──→ network-load-balancer
              ├──→ bastion
              └──→ mysql

vault ──→ certificates ──→ credentials

notifications ──→ monitoring

# Independent (no dependencies):
autonomous-database    nosql-database     apm
object-storage         email-delivery     logging
site-to-site-vpn
```

## Always Free Tier Limits

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

## Multi-Account / Multi-Region Patterns

### Deploy the same environment across regions

```bash
# Seoul — development
cd terragrunt/personal/ap-seoul-1/development
terragrunt run-all apply

# Ashburn — development (same account, different region)
cd terragrunt/personal/us-ashburn-1/development
terragrunt run-all apply
```

### Deploy to a different account

```bash
# 1. Create the account directory
mkdir -p terragrunt/company/us-phoenix-1/production

# 2. Create account.hcl with the company tenancy
cat > terragrunt/company/account.hcl <<'EOF'
locals {
  account_name        = "company"
  tenancy_ocid        = "ocid1.tenancy.oc1..yyyy"
  compartment_id      = "ocid1.compartment.oc1..yyyy"
  namespace           = "company-namespace"
  config_file_profile = "company"   # ~/.oci/config profile
}
EOF

# 3. Create region.hcl and env.hcl, copy module dirs
# 4. terragrunt run-all apply
```

### Switching to ARM (VM.Standard.A1.Flex)

Edit `<account>/<region>/<env>/compute/terragrunt.hcl`:

```hcl
inputs = {
  shape          = "VM.Standard.A1.Flex"
  instance_count = 1
  ocpus          = 4
  memory_in_gbs  = 24
}
```

## Common Commands

```bash
# Validate all modules (no OCI calls)
terragrunt run-all validate --terragrunt-ignore-external-dependencies

# Plan everything
terragrunt run-all plan

# Apply (CI — non-interactive)
terragrunt run-all apply --terragrunt-non-interactive

# Destroy everything (reverse dependency order)
terragrunt run-all destroy

# Show dependency graph
terragrunt graph-dependencies | dot -Tpng > deps.png

# Force re-init (after provider version bumps)
terragrunt run-all init --upgrade
```

## Security Notes

- **Secrets** (`adb_admin_password`, `mysql_admin_password`, SSH keys) are passed via `TF_VAR_*` env vars — never committed to `.hcl` files.
- **OCI API keys** stay in `~/.oci/` — provider reads them automatically via `config_file_profile`.
- **State bucket** should have versioning enabled and access restricted to your IAM group.
- **Bastion** `client_cidr_block_allow_list` should be restricted to known IPs in production.
- **account.hcl** contains OCIDs (not secrets), but treat it as infrastructure config — don't expose publicly if your tenancy OCID is sensitive.

## Troubleshooting

| Error | Fix |
|-------|-----|
| `No valid credential sources found` | Run `oci setup config` or check `config_file_profile` in `account.hcl` matches `~/.oci/config` |
| `failed to get object storage namespace` | Verify `namespace` in `account.hcl` matches `oci os ns get` output |
| `Error accessing state bucket` | Create the bucket or check `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` |
| `Could not find account.hcl` | Ensure you are running from inside `<account>/<region>/<env>/<module>/` |
| `Could not find region.hcl` | Ensure `region.hcl` exists in `<account>/<region>/` |
| `mock_outputs not matching` | Normal for `plan` — mock outputs are used when a dependency hasn't been applied yet |
| `availability_domain not set` | Set `TF_VAR_availability_domain` (e.g., `oci-yourdomain-ad-1`) |

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [OCI Terraform Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
- [OCI Object Storage S3 Compatibility](https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/s3compatibleapi.htm)
- [Gruntwork Reference Architecture](https://gruntwork.io/reference-architecture/)
