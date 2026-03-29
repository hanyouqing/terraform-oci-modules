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
      secret_name    = "my-secret"
      # Use a placeholder in docs; load real secret_content from Vault/CI, not plaintext in repo
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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 7.30 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_kms_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key) | resource |
| [oci_kms_vault.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_vault) | resource |
| [oci_vault_secret.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vault_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the vault will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (KMS/vault resources expect map(string)) | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_keys"></a> [keys](#input\_keys) | Map of keys to create | <pre>map(object({<br/>    display_name    = string<br/>    algorithm       = string<br/>    length          = optional(number, null)<br/>    curve_id        = optional(string, null)<br/>    protection_mode = string<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets to create (secret\_name maps to oci\_vault\_secret.secret\_name) | <pre>map(object({<br/>    secret_name    = string<br/>    secret_content = string<br/>    content_type   = string<br/>    key_id         = string<br/>  }))</pre> | `{}` | no |
| <a name="input_vault_display_name"></a> [vault\_display\_name](#input\_vault\_display\_name) | Display name for the vault | `string` | `"vault"` | no |
| <a name="input_vault_type"></a> [vault\_type](#input\_vault\_type) | Type of vault: VIRTUAL\_PRIVATE or DEFAULT | `string` | `"DEFAULT"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_ids"></a> [key\_ids](#output\_key\_ids) | OCIDs of the keys |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | OCIDs of the secrets |
| <a name="output_vault_crypto_endpoint"></a> [vault\_crypto\_endpoint](#output\_vault\_crypto\_endpoint) | Crypto endpoint of the vault |
| <a name="output_vault_id"></a> [vault\_id](#output\_vault\_id) | OCID of the vault |
| <a name="output_vault_management_endpoint"></a> [vault\_management\_endpoint](#output\_vault\_management\_endpoint) | Management endpoint of the vault |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Vault module |
<!-- END_TF_DOCS -->
