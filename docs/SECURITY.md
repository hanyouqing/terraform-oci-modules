# Security practices for this repository

This document summarizes how this project avoids storing **passwords, API keys, tokens, and other secrets** in version control, and how to handle them safely in Terraform and OCI.

## What must not be committed

| Item | Why | Mitigation |
|------|-----|------------|
| **Terraform state** (`.tfstate`) | Often contains secrets and resource identifiers | Listed in `.gitignore`; use a [remote backend](https://developer.hashicorp.com/terraform/language/settings/backends) with encryption and strict IAM |
| **`.tfvars` / `*.tfvars.json`** | Typical place for passwords and OCIDs | Ignored by `.gitignore`; use `.tfvars` only locally or via CI injection |
| **`.env.sh`, `.env`, `credentials/*.env`** | OCI keys, compartments, DB passwords | Ignored; use templates (`.env.sh.example`, `credentials/example.env.example`) only |
| **Private keys** (`*.pem`, SSH keys) | Signing and access | Keep under `~/.oci/` or a secret store; `*.pem` is ignored to reduce accidental adds |
| **Terraform plan files** | Can echo sensitive values from config | `*.tfplan` / `*.tfplan` patterns ignored |
| **Example passwords in docs** | Copy-paste into real configs | Docs use placeholders; set real values only via env or secret managers |

## Environment variables

- **OCI API keys**: Use `OCI_PRIVATE_KEY_PATH` to a file outside the repo, not `OCI_PRIVATE_KEY` (inline PEM) in shared env files.
- **Database / app passwords**: Pass via `TF_VAR_*` from CI secret stores, `read -s`, or tools like 1Password CLI—**never** echo them in `show_config` or commit them in `.env.sh`.
- **Object Storage backend keys** (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` for S3-compatible state): Treat like production credentials; rotate Customer Secret Keys regularly.

## Terraform: `sensitive` variables

Module variables that carry passwords or secret payloads use `sensitive = true` where supported (e.g. `databases`, `mysql_systems`, `secrets` maps) so Terraform redacts them in **plan and apply** output when possible. **State files may still contain secret values**—protect the backend.

## Code review checklist

1. No new `*.tfvars` with real secrets checked in.
2. No real OCIDs/passwords in examples—only placeholders.
3. No private keys or `.env` files in commits.
4. CI pipelines inject secrets from the platform’s secret store, not hardcoded in YAML.

## Tools in this repo

- **TFSec / Checkov** (`make security`) — static checks for misconfigurations.
- **`.tfsec.yml`** — project exclusions and severity.

For OCI-specific Terraform guidance, see [OCI Terraform best practices](https://docs.oracle.com/en-us/iaas/Content/terraform/best-practices.htm).
