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
├── root.hcl                       # Root config: remote state, provider gen, shared inputs
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
Root root.hcl                                 → provider_tg.tf + backend.tf + shared inputs
  └─ <account>/account.hcl                    → tenancy_ocid, compartment_id, namespace, profile
      └─ <account>/<region>/region.hcl        → region
          └─ _envcommon/<module>.hcl           → terraform.source + module defaults
              └─ <account>/<region>/<env>/<module>/terragrunt.hcl → env-specific overrides + dependencies
```

**Root `root.hcl`** provides:
- Remote state ([Terraform `backend "oci"`](https://developer.hashicorp.com/terraform/language/backend/oci) — Object Storage, same OCI API key as the provider)
- Provider generation (`provider_tg.tf`) with region and OCI profile from `account.hcl`
- Shared inputs: `project`, `environment`, `compartment_id`, `tenancy_ocid`, `freeform_tags`

`_envcommon/*.hcl` uses **local** `terraform.source` paths (`../<module>`) so workspace edits apply before push. For published stacks, pin a git ref instead, for example:

`source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//compute?ref=vX.Y.Z"`

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

### 5. Remote State (Terraform `backend "oci"`)

Remote state uses Oracle’s **recommended** native backend ([Using Object Storage for State Files](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm), [HashiCorp: `backend "oci"`](https://developer.hashicorp.com/terraform/language/backend/oci)). It requires **Terraform ≥ 1.12** (this repo’s modules use **≥ 1.14.2**). Authentication is the **same OCI API key profile** as the Terraform provider (`config_file_profile` in `account.hcl`, typically `~/.oci/config`). `root.hcl` sets `OCI_CLI_CONFIG_FILE` for Terraform so the backend and provider share one config file (per-account path `~/.oci/<account_name>/config` when `account_name` is not the placeholder; otherwise `~/.oci/config`).

**Create the state bucket once** (name must match `local.state_bucket` in `root.hcl`: `<project>-tfstate`):

```bash
oci os bucket create \
  --compartment-id "ocid1.compartment.oc1..xxxx" \
  --name "oci-modules-tfstate" \
  --versioning Enabled
```

Grant your user IAM access to **OBJECT_READ / OBJECT_INSPECT / OBJECT_CREATE / OBJECT_DELETE** on that bucket ([Oracle: permissions](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm)).

State object key layout: `<region>/<environment>/<module>/terraform.tfstate` — isolated per account, region, and environment.

Run `terragrunt init` / `plan` after the bucket exists.

**Migrating from the previous S3-compatible backend:** If you already had state in the same bucket and key, run `terragrunt init` and confirm **state migration** when Terraform asks. If the state object disappeared from the wrong backend config, restore it from bucket **versioning** or use `terraform state pull` with a temporary old backend block.

### 5a. Object Storage stack: importing the tfstate bucket (circular dependency)

Remote state is stored **in** the same Object Storage bucket that the **`object-storage`** module manages. Terraform cannot create that bucket on first apply (state is not available yet), so **create the bucket once** (§5), then **import** it into the `object-storage` workspace.

The `object-storage` stack can **generate** `import.tf` via a `generate` block in `terragrunt/personal/.../object-storage/terragrunt.hcl` when **`TG_IMPORT_TFSTATE_BUCKET=true`** and **`TF_VAR_namespace`** is set (same namespace the module uses). Otherwise it writes a short comment stub. See also the template comments in [object-storage/import.tf](../object-storage/import.tf) in the module.

1. **Create** the bucket (Console or `oci os bucket create`) using the same name as `local.tfstate_bucket_name` / `local.state_bucket` in `terragrunt.hcl` and [root.hcl](root.hcl) (e.g. `<project>-tfstate` in this repo).
2. **Export** the Object Storage namespace (required for module inputs and import generation):
   ```bash
   export TF_VAR_namespace="$(oci os ns get --query data --raw-output)"
   ```
3. **Import** using the provider’s **composite** ID (importing by bucket OCID alone can error on refresh):
   ```text
   n/<namespace>/b/<bucket_name>
   ```
   - **Terraform 1.5+ (generated):**  
     `export TG_IMPORT_TFSTATE_BUCKET=true` → `terragrunt plan` / `terragrunt apply` once → unset `TG_IMPORT_TFSTATE_BUCKET` or set it to `false` after the import is applied.  
   - **CLI:** `terragrunt init` then  
     `terragrunt run -- import 'oci_objectstorage_bucket.this["<stack-dir-basename>"]' 'n/<namespace>/b/<bucket_name>'` (map key matches the **directory name** of the stack, e.g. `object-storage`.)
4. **Apply** the module as usual so Terraform owns lifecycle (versioning, tags, etc.).

Apply **`object-storage` before** other stacks that assume the bucket exists, or keep using the manually created bucket until this import is done.

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
export TF_VAR_bastion_allowed_cidr="203.0.113.10/32"
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
| `BucketNotFound` / `does not exist in the namespace` on **`terraform init`** | **Namespace:** `TF_VAR_namespace` must be the **Object Storage namespace** from `oci os ns get --query data --raw-output` — not your account name. Wrong namespace → wrong URL and 404. Leave `TF_VAR_namespace` unset (or `REPLACE_ME`) so `root.hcl` runs `oci os ns get`, or set it to the exact CLI value. **Bucket:** create it once: `oci os bucket create --compartment-id <ocid> --name "<project>-tfstate" --versioning Enabled` (name must match `local.state_bucket` in `root.hcl`). |
| `Error accessing state bucket` / backend auth failures | Create the bucket (`<project>-tfstate`), verify `namespace` and `region`, and ensure `~/.oci/config` (or `OCI_CLI_CONFIG_FILE`) has a valid API key profile. IAM must allow Object Storage access on that bucket. |
| `No valid credential sources` (backend) | Same as provider: check `config_file_profile`, `OCI_CLI_CONFIG_FILE`, and file permissions on the API key (`chmod 600`). |
| `Permissions on ~/.oci/config are too open` | Run `oci setup repair-file-permissions --file ~/.oci/config` (or set `OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True` to hide the warning only). |
| `Backend initialization required` on **`terragrunt init`** (often `terraform output` on `../vcn`) | Dependency mocks now include **`init`** so init does not require the dependency to be initialized first. Or init dependencies first: `cd ../vcn && terragrunt init`, or `terragrunt run-all init` from the env directory. |
| `Could not find account.hcl` | Ensure you are running from inside `<account>/<region>/<env>/<module>/` |
| `Could not find region.hcl` | Ensure `region.hcl` exists in `<account>/<region>/` |
| `mock_outputs not matching` | Normal for `plan` — mock outputs are used when a dependency hasn't been applied yet |
| `availability_domain not set` | Set `TF_VAR_availability_domain` (e.g., `oci-yourdomain-ad-1`) |

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [OCI Terraform Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
- [Terraform backend `oci`](https://developer.hashicorp.com/terraform/language/backend/oci)
- [Gruntwork Reference Architecture](https://gruntwork.io/reference-architecture/)
