# Vault Module

This module creates and manages Vaults, Keys, and Secrets in Oracle Cloud Infrastructure.

## Features

- Create Vaults (Virtual Private or Default)
- Key management (software and HSM keys)
- Secret management
- Comprehensive tagging support

## Always Free Limits

- **Software Master Keys**: Unlimited
- **HSM Master Key Versions**: 20
- **Secrets**: 150

## Usage

```hcl
module "vault" {
  source = "../vault"

  compartment_id     = var.compartment_id
  vault_display_name = "my-vault"
  vault_type         = "DEFAULT"

  keys = {
    master-key = {
      display_name   = "master-key"
      algorithm      = "AES"
      length         = 32
      curve_id       = null
      protection_mode = "SOFTWARE"
    }
  }

  secrets = {
    my-secret = {
      display_name   = "my-secret"
      secret_content = base64encode("my-secret-value")
      content_type   = "BASE64"
      key_id         = module.vault.key_ids["master-key"]
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 6.0 |

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, vault type, and key usage.

### Always Free Tier

The following Vault resources are **free** within Always Free tier limits:
- **Software Master Keys**: Unlimited
- **HSM Master Key Versions**: 20 versions
- **Secrets**: 150 secrets
- **Default Vault**: Free for software keys

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Vaults** | | |
| Default Vault | Software keys only | **$0** (Free) |
| Virtual Private Vault | HSM keys support | ~**$200-250** |
| **Keys** | | |
| Software Keys | Unlimited | **$0** (Free) |
| HSM Key Versions | Per version beyond 20 | ~**$2-3/version/month** |
| HSM Key Operations | Per operation | ~**$0.01-0.02/operation** |
| **Secrets** | | |
| Secrets (0-150) | First 150 secrets | **$0** (Free) |
| Secrets (151-1000) | Additional secrets | ~**$0.10-0.15/secret/month** |
| Secrets (1000+) | Bulk pricing | ~**$0.05-0.10/secret/month** |
| **Total (Default Vault + 200 secrets)** | Small production | **~$5-7.50/month** |
| **Total (Virtual Private Vault + 500 secrets)** | Medium production | **~$235-280/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes unlimited software keys and 150 secrets
> - Default Vault is free for software keys
> - Virtual Private Vault is required for HSM keys and has a base cost
> - HSM key operations have per-operation charges
> - To minimize costs, use Default Vault with software keys when possible

### Cost Optimization Tips

1. **Use Default Vault** with software keys (free) when HSM is not required
2. **Use software keys** instead of HSM keys when security requirements allow
3. **Consolidate secrets** to stay within Always Free tier (150 secrets)
4. **Use Virtual Private Vault** only when HSM keys are required
5. **Monitor key operations** to optimize HSM usage costs
6. **Review secret usage** and archive unused secrets

## Examples

See the [examples](../examples/vault/) directory for complete examples.
