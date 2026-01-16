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

## Examples

See the [examples](../examples/vault/) directory for complete examples.
