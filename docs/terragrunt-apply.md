# Terragrunt Apply — GitHub Actions CD Pipeline

This document describes how to set up the `Terragrunt Apply (Development)` workflow that automatically plans and applies infrastructure changes to the `personal/ap-seoul-1/development` environment.

## Workflow Behavior

| Trigger | Action |
|---------|--------|
| **Push to `main`** (terragrunt files changed) | Auto-plan only |
| **Pull request** | Plan + post summary as PR comment |
| **Manual dispatch → plan** | Plan only |
| **Manual dispatch → apply** | Plan → Apply (requires `development` environment approval) |
| **Manual dispatch → destroy** | Plan → Destroy (requires `development` environment approval) |

The `apply` and `destroy` actions require the GitHub **`development` environment** with protection rules (see below).

You can optionally specify individual modules (e.g., `vcn compute`) to target instead of applying all 19 modules.

## Required GitHub Secrets

Configure these in **Settings → Secrets and variables → Actions → Repository secrets**.

### OCI API Key Authentication

These secrets are used to generate `~/.oci/config` at runtime so the OCI Terraform provider can authenticate.

| Secret | Description | How to get it |
|--------|-------------|---------------|
| `OCI_CLI_TENANCY` | Tenancy OCID | OCI Console → Governance → Tenancy Details |
| `OCI_CLI_USER` | User OCID | OCI Console → Identity → Users → your user |
| `OCI_CLI_FINGERPRINT` | API key fingerprint | OCI Console → Identity → Users → API Keys |
| `OCI_CLI_KEY_CONTENT` | API private key (**base64-encoded**) | See [Encoding the API Key](#encoding-the-api-key) |

### Remote State Backend

The Terragrunt remote state uses OCI Object Storage via its S3-compatible API. These credentials are separate from the API key.

| Secret | Description | How to get it |
|--------|-------------|---------------|
| `OCI_S3_ACCESS_KEY` | Customer Secret Key ID | OCI Console → Identity → Users → Customer Secret Keys |
| `OCI_S3_SECRET_KEY` | Customer Secret Key | Shown once when key is created — save immediately |
| `OCI_NAMESPACE` | Object Storage namespace | Run `oci os ns get --query 'data' --raw-output` |

### Account & Infrastructure

| Secret | Description | How to get it |
|--------|-------------|---------------|
| `OCI_COMPARTMENT_ID` | Compartment OCID for resources | OCI Console → Identity → Compartments |
| `OCI_AVAILABILITY_DOMAIN` | Availability domain name | `oci iam availability-domain list --query 'data[0].name' --raw-output` |

### Module-Specific (Optional)

These are only needed if the corresponding modules are deployed. Modules with empty values will use defaults or skip resources.

| Secret | Used by | Description |
|--------|---------|-------------|
| `SSH_PUBLIC_KEYS` | compute | SSH public key for instance access |
| `ALERT_EMAIL` | notifications, monitoring | Email for alarm notifications |
| `SENDER_EMAIL` | email-delivery | Approved sender email address |
| `BASTION_ALLOWED_CIDR` | bastion | CIDR allowed to connect (e.g., `203.0.113.0/32`) |
| `ADB_ADMIN_PASSWORD` | autonomous-database | Admin password (min 12 chars, 1 upper, 1 number, 1 special) |
| `MYSQL_ADMIN_PASSWORD` | mysql | Admin password (min 8 chars) |

## Setup Instructions

### 1. Generate an OCI API Key

If you don't already have one:

```bash
# Generate a 2048-bit RSA key pair
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
chmod 600 ~/.oci/oci_api_key.pem

# Upload the PUBLIC key to OCI Console:
#   Identity → Users → your user → API Keys → Add API Key → Paste Public Key
cat ~/.oci/oci_api_key_public.pem
```

### 2. Encoding the API Key

The workflow stores the private key as a base64-encoded GitHub secret to preserve line breaks:

```bash
# macOS
base64 -i ~/.oci/oci_api_key.pem | pbcopy
# Linux
base64 -w 0 ~/.oci/oci_api_key.pem | xclip -selection clipboard
```

Paste the result as the `OCI_CLI_KEY_CONTENT` secret.

### 3. Create a Customer Secret Key (for state backend)

```bash
# Via OCI Console: Identity → Users → your user → Customer Secret Keys → Generate
# Or via CLI:
oci iam customer-secret-key create \
  --user-id "ocid1.user.oc1..xxxx" \
  --display-name "terragrunt-state-github-actions"
```

Save the returned `id` as `OCI_S3_ACCESS_KEY` and `key` as `OCI_S3_SECRET_KEY`.

### 4. Create the State Bucket

```bash
oci os bucket create \
  --compartment-id "ocid1.compartment.oc1..xxxx" \
  --name "tfstate-personal-oci-modules" \
  --versioning Enabled
```

### 5. Create the GitHub Environment

1. Go to **Settings → Environments → New environment**
2. Name: `development`
3. (Recommended) Add **Required reviewers** — this gates `apply` and `destroy` actions
4. (Optional) Add **Wait timer** or restrict to specific branches

### 6. Add All Secrets

Go to **Settings → Secrets and variables → Actions** and add each secret listed above.

### Quick Secret Checklist

```
✅ OCI_CLI_TENANCY          = ocid1.tenancy.oc1..xxxx
✅ OCI_CLI_USER             = ocid1.user.oc1..xxxx
✅ OCI_CLI_FINGERPRINT      = aa:bb:cc:dd:...
✅ OCI_CLI_KEY_CONTENT      = <base64 of ~/.oci/oci_api_key.pem>
✅ OCI_S3_ACCESS_KEY        = <customer secret key id>
✅ OCI_S3_SECRET_KEY        = <customer secret key>
✅ OCI_NAMESPACE            = <object storage namespace>
✅ OCI_COMPARTMENT_ID       = ocid1.compartment.oc1..xxxx
✅ OCI_AVAILABILITY_DOMAIN  = xxxx:AP-SEOUL-1-AD-1
☐ SSH_PUBLIC_KEYS           (optional — for compute)
☐ ALERT_EMAIL               (optional — for monitoring)
☐ SENDER_EMAIL              (optional — for email-delivery)
☐ BASTION_ALLOWED_CIDR      (optional — for bastion)
☐ ADB_ADMIN_PASSWORD        (optional — for autonomous-database)
☐ MYSQL_ADMIN_PASSWORD      (optional — for mysql)
```

## Usage

### Plan all modules (manual)

```
Actions → Terragrunt Apply (Development) → Run workflow → action: plan
```

### Apply specific modules

```
Actions → Run workflow → action: apply → modules: "vcn compute bastion"
```

Modules are applied sequentially in the order specified. Use Terragrunt dependency order:
1. `vcn` (first — everything depends on it)
2. `notifications` (independent)
3. `compute`, `bastion`, `load-balancer`, `mysql` (depend on vcn)
4. `block-storage` (depends on compute)
5. `monitoring` (depends on notifications)

### Apply everything

```
Actions → Run workflow → action: apply → modules: (leave empty)
```

Terragrunt `run-all` resolves dependencies automatically.

### Destroy

```
Actions → Run workflow → action: destroy → modules: (leave empty or specific)
```

## Security Considerations

- **No secrets in code**: All sensitive values come from GitHub Secrets, never from `.hcl` files.
- **Environment protection**: The `development` environment should have required reviewers to prevent accidental applies.
- **Concurrency lock**: Only one apply/destroy can run at a time (`concurrency.group`).
- **State encryption**: Enable server-side encryption on the state bucket in OCI Console.
- **Least privilege**: Create a dedicated OCI user with only the policies needed for the deployed resources. See [OCI IAM Policies](https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm).
- **Key rotation**: Rotate the API key and Customer Secret Key periodically. Update the GitHub secrets after rotation.

## Troubleshooting

| Error | Fix |
|-------|-----|
| `No valid credential sources found` | Check `OCI_CLI_TENANCY`, `OCI_CLI_USER`, `OCI_CLI_FINGERPRINT`, `OCI_CLI_KEY_CONTENT` secrets |
| `Error: invalid base64 data` | Re-encode the PEM file: `base64 -w 0 ~/.oci/oci_api_key.pem` (use `-i` on macOS) |
| `Error accessing state bucket` | Verify `OCI_S3_ACCESS_KEY`, `OCI_S3_SECRET_KEY`, and `OCI_NAMESPACE` secrets |
| `Bucket does not exist` | Create the bucket: `oci os bucket create --name tfstate-personal-oci-modules ...` |
| `Environment 'development' not found` | Create the environment in Settings → Environments |
| `Resource already exists` | State may be out of sync — run `terragrunt import` or check for manual changes |
