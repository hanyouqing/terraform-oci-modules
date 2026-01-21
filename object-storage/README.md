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

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, storage tier, and data transfer volumes.

### Always Free Tier

The following Object Storage resources are **free** within Always Free tier limits:
- **Total Storage**: 20 GB (free tier accounts)
- **API Requests**: 50,000 requests per month
- **Storage Tiers**: Standard, Infrequent Access, Archive

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Storage** | | |
| Standard Storage | 100 GB | ~**$1.20-1.50** |
| Standard Storage | 500 GB | ~**$6-7.50** |
| Standard Storage | 1 TB | ~**$12-15** |
| Infrequent Access Storage | 100 GB | ~**$0.60-0.75** |
| Infrequent Access Storage | 500 GB | ~**$3-3.75** |
| Archive Storage | 100 GB | ~**$0.10-0.12** |
| Archive Storage | 500 GB | ~**$0.50-0.60** |
| **API Requests** | | |
| PUT/POST Requests | 100,000 requests | ~**$0.50-1** |
| GET/HEAD Requests | 1,000,000 requests | ~**$0.50-1** |
| **Data Transfer** | | |
| Data Transfer Out | 100 GB/month | ~**$9-10** |
| Data Transfer Out | 500 GB/month | ~**$45-50** |
| **Total (100 GB Standard + 100 GB transfer)** | Basic setup | **~$11-13/month** |
| **Total (500 GB Standard + 500 GB transfer)** | Medium usage | **~$52-60/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 20 GB storage and 50,000 API requests
> - Archive storage is significantly cheaper but has retrieval costs
> - Data transfer costs apply to outbound internet traffic
> - Lifecycle policies can automatically move objects to cheaper tiers
> - To minimize costs, use lifecycle policies to transition to Infrequent Access or Archive tiers

### Cost Optimization Tips

1. **Use Always Free tier** (20 GB) when possible
2. **Implement lifecycle policies** to automatically move objects to cheaper tiers
3. **Use Infrequent Access** for data accessed less than once per month
4. **Use Archive storage** for long-term retention with infrequent access
5. **Optimize API requests** by batching operations when possible
6. **Use Service Gateway** for OCI service access (free, no data transfer charges)

## Examples

See the [examples](../examples/object-storage/) directory for complete examples.
