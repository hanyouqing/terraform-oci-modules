# Object Storage Module

This module creates and manages Object Storage buckets in Oracle Cloud Infrastructure, including lifecycle policies and pre-authenticated requests.

## Features

- Create multiple buckets with different storage tiers
- Lifecycle policy management
- Pre-authenticated request support
- Versioning support
- Access type configuration
- Comprehensive tagging support

## Always Free Limits

- **Total Storage**: 20 GB (free tier accounts)
- **API Requests**: 50,000 requests per month
- **Storage Tiers**: Standard, Infrequent Access, Archive

## Usage

```hcl
module "object_storage" {
  source = "../object-storage"

  compartment_id = var.compartment_id
  region         = var.region

  buckets = {
    my-bucket = {
      name         = "my-bucket"
      namespace    = null
      access_type  = "NoPublicAccess"
      storage_tier = "Standard"
      versioning   = "Disabled"
      freeform_tags = {}
      defined_tags  = {}
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

## Providers

| Name | Version |
|------|---------|
| oci | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment where the buckets will be created | `string` | n/a | yes |
| region | OCI region for bucket URIs | `string` | `""` | no |
| buckets | Map of buckets to create | `map(object)` | `{}` | no |
| lifecycle_policies | Map of lifecycle policies to create | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_names | Names of the buckets |
| bucket_namespaces | Namespaces of the buckets |
| bucket_uris | URIs of the buckets |
| namespace | Object Storage namespace |

## Examples

See the [examples](../examples/object-storage/) directory for complete examples.
