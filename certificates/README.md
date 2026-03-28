# Certificates Module

This module creates and manages Certificate Authorities (CAs) and certificates using Oracle Cloud Infrastructure Certificates Management Service.

## Features

- Create Root CAs (internally generated)
- Create Subordinate CAs (issued by internal root CA)
- Issue TLS certificates (server, client, code signing)
- Subject Alternative Names (SANs) support
- Configurable validity periods and maximum duration rules
- Multiple key/signing algorithms (RSA2048/4096, ECDSA P256/P384)
- Comprehensive tagging support

## Always Free Limits

- **Certificate Authorities**: Up to 5 per tenancy
- **Certificates**: Up to 150 per tenancy
- **KMS Keys** (for CA protection): Unlimited software keys (free via Vault module)

## Usage

```hcl
module "certificates" {
  source = "../certificates"

  compartment_id = var.compartment_id

  certificate_authorities = {
    root-ca = {
      name           = "my-root-ca"
      kms_key_id     = var.kms_key_id
      common_name    = "My Root CA"
      organization   = "My Organization"
      country        = "US"
    }
  }

  certificates = {
    web-cert = {
      name        = "web-server-cert"
      ca_key      = "root-ca"
      common_name = "app.example.com"
      subject_alternative_names = [
        { type = "DNS", value = "app.example.com" },
        { type = "DNS", value = "*.app.example.com" }
      ]
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Prerequisites

This module requires a KMS key for CA private key protection. Use the [vault module](../vault/) to create one:

```hcl
module "vault" {
  source = "../vault"

  compartment_id     = var.compartment_id
  vault_display_name = "ca-vault"
  vault_type         = "DEFAULT"

  keys = {
    ca-key = {
      display_name    = "ca-master-key"
      algorithm       = "AES"
      length          = 32
      protection_mode = "SOFTWARE"
    }
  }
}

# Then reference: kms_key_id = module.vault.key_ids["ca-key"]
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| oci | ~> 7.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment | `string` | n/a | yes |
| certificate_authorities | Map of CAs to create | `map(object)` | `{}` | no |
| certificates | Map of certificates to create | `map(object)` | `{}` | no |
| project | Project name for tagging | `string` | `"oci-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| freeform_tags | Freeform tags for all resources | `map(string)` | `{}` | no |
| defined_tags | Defined tags for all resources | `map(map(string))` | `{}` | no |

### Certificate Authority Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| name | CA display name | `string` | — |
| kms_key_id | OCID of KMS key for CA protection | `string` | — |
| common_name | CA subject common name | `string` | — |
| config_type | ROOT_CA_GENERATED_INTERNALLY or SUBORDINATE_CA_ISSUED_BY_INTERNAL_CA | `string` | `"ROOT_CA_GENERATED_INTERNALLY"` |
| signing_algorithm | Signing algorithm | `string` | `"SHA256_WITH_RSA"` |
| key_algorithm | Key algorithm | `string` | `"RSA2048"` |
| country | Subject country | `string` | `null` |
| organization | Subject organization | `string` | `null` |
| time_of_validity_not_after | Validity end (ISO 8601) | `string` | `null` |
| certificate_authority_max_validity_duration | Max CA validity (ISO 8601 duration) | `string` | `null` |
| leaf_certificate_max_validity_duration | Max leaf cert validity (ISO 8601 duration) | `string` | `null` |

### Certificate Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| name | Certificate display name | `string` | — |
| common_name | Subject common name | `string` | — |
| ca_key | Key in `certificate_authorities` map | `string` | `null` |
| issuer_certificate_authority_id | External CA OCID (if not using ca_key) | `string` | `null` |
| certificate_profile_type | TLS_SERVER_OR_CLIENT, TLS_SERVER, TLS_CLIENT, TLS_CODE_SIGN | `string` | `"TLS_SERVER_OR_CLIENT"` |
| subject_alternative_names | SANs list (type + value) | `list(object)` | `[]` |
| time_of_validity_not_after | Validity end (ISO 8601) | `string` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| certificate_authority_ids | OCIDs of the CAs |
| certificate_authority_names | Names of the CAs |
| certificate_authority_states | Lifecycle states of the CAs |
| certificate_ids | OCIDs of the certificates |
| certificate_names | Names of the certificates |
| certificate_states | Lifecycle states of the certificates |

## Cost Estimate

### Always Free Tier

The following Certificates resources are **free** within Always Free tier limits:
- **5 Certificate Authorities** (root and subordinate)
- **150 Certificates** (any profile type)
- **KMS Software Keys**: Unlimited (free via Vault module)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Certificate Authorities** | | |
| CAs (1-5) | Within Always Free | **$0** (Free) |
| CAs (6+) | Additional CAs | ~**$50-100/CA/month** |
| **Certificates** | | |
| Certificates (1-150) | Within Always Free | **$0** (Free) |
| Certificates (151+) | Additional certificates | ~**$0.25-0.50/cert/month** |
| **KMS Key** (for CA) | | |
| Software Key | Default Vault | **$0** (Free) |
| HSM Key | Virtual Private Vault | ~**$200-250/month** (vault cost) |

> **Notes:**
> - Prices vary by region; estimates based on typical OCI pricing
> - Always Free tier is per-tenancy, not per-compartment
> - CAs require a KMS key — use software keys to stay free
> - Certificate auto-renewal is handled by the service

### Cost Optimization Tips

1. **Use Always Free tier** (5 CAs, 150 certificates) for most use cases
2. **Use software KMS keys** in Default Vault (free) for CA protection
3. **Use wildcard certificates** to reduce total certificate count
4. **Share CAs** across services — one root CA is sufficient for most orgs
5. **Use subordinate CAs** for different environments (dev, staging, prod)

## Examples

- [Basic](examples/basic/) — Single root CA (Always Free)
- [Complete](examples/complete/) — Root CA + subordinate CA + certificates with SANs
