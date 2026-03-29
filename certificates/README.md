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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_certificates_management_certificate.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/certificates_management_certificate) | resource |
| [oci_certificates_management_certificate_authority.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/certificates_management_certificate_authority) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_authorities"></a> [certificate\_authorities](#input\_certificate\_authorities) | Map of Certificate Authorities to create. Always Free: 5 CAs per tenancy. | <pre>map(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    kms_key_id  = string<br/><br/>    # CA config<br/>    config_type                     = optional(string, "ROOT_CA_GENERATED_INTERNALLY")<br/>    issuer_certificate_authority_id = optional(string, null)<br/>    signing_algorithm               = optional(string, "SHA256_WITH_RSA")<br/>    key_algorithm                   = optional(string, "RSA2048")<br/>    version_name                    = optional(string, null)<br/><br/>    # Subject<br/>    common_name         = string<br/>    country             = optional(string, null)<br/>    organization        = optional(string, null)<br/>    organizational_unit = optional(string, null)<br/>    state_name          = optional(string, null)<br/>    locality            = optional(string, null)<br/><br/>    # Validity (ISO 8601 timestamps)<br/>    time_of_validity_not_before = optional(string, null)<br/>    time_of_validity_not_after  = optional(string, null)<br/><br/>    # Rules<br/>    certificate_authority_max_validity_duration = optional(string, null)<br/>    leaf_certificate_max_validity_duration      = optional(string, null)<br/><br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | Map of certificates to create. Always Free: 150 certificates per tenancy. Use ca\_key to reference a CA in certificate\_authorities, or issuer\_certificate\_authority\_id for an external CA OCID. | <pre>map(object({<br/>    name        = string<br/>    description = optional(string, "")<br/><br/>    # Certificate config<br/>    config_type              = optional(string, "ISSUED_BY_INTERNAL_CA")<br/>    certificate_profile_type = optional(string, "TLS_SERVER_OR_CLIENT")<br/>    key_algorithm            = optional(string, "RSA2048")<br/>    signature_algorithm      = optional(string, "SHA256_WITH_RSA")<br/><br/>    # Reference to CA — either a key in certificate_authorities or a direct OCID<br/>    ca_key                          = optional(string, null)<br/>    issuer_certificate_authority_id = optional(string, null)<br/><br/>    # Subject<br/>    common_name         = string<br/>    country             = optional(string, null)<br/>    organization        = optional(string, null)<br/>    organizational_unit = optional(string, null)<br/>    state_name          = optional(string, null)<br/>    locality            = optional(string, null)<br/><br/>    # Subject Alternative Names<br/>    subject_alternative_names = optional(list(object({<br/>      type  = string<br/>      value = string<br/>    })), [])<br/><br/>    # Validity (ISO 8601 timestamps)<br/>    time_of_validity_not_before = optional(string, null)<br/>    time_of_validity_not_after  = optional(string, null)<br/><br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where certificate authorities and certificates will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_authority_ids"></a> [certificate\_authority\_ids](#output\_certificate\_authority\_ids) | OCIDs of the Certificate Authorities |
| <a name="output_certificate_authority_names"></a> [certificate\_authority\_names](#output\_certificate\_authority\_names) | Names of the Certificate Authorities |
| <a name="output_certificate_authority_states"></a> [certificate\_authority\_states](#output\_certificate\_authority\_states) | Lifecycle states of the Certificate Authorities |
| <a name="output_certificate_ids"></a> [certificate\_ids](#output\_certificate\_ids) | OCIDs of the certificates |
| <a name="output_certificate_names"></a> [certificate\_names](#output\_certificate\_names) | Names of the certificates |
| <a name="output_certificate_states"></a> [certificate\_states](#output\_certificate\_states) | Lifecycle states of the certificates |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Certificates module |
<!-- END_TF_DOCS -->
