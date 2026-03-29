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
| [oci_objectstorage_bucket.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket) | resource |
| [oci_objectstorage_object_lifecycle_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object_lifecycle_policy) | resource |
| [oci_objectstorage_preauthrequest.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_preauthrequest) | resource |
| [oci_objectstorage_namespace.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of buckets to create. name must be alphanumeric with no spaces, max 256 characters. storage\_tier can be Standard or Archive. | <pre>map(object({<br/>    name          = string<br/>    namespace     = optional(string, null)<br/>    access_type   = optional(string, "NoPublicAccess")<br/>    storage_tier  = optional(string, "Standard")<br/>    versioning    = optional(string, "Enabled")<br/>    kms_key_id    = optional(string, null)<br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the buckets will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_lifecycle_policies"></a> [lifecycle\_policies](#input\_lifecycle\_policies) | Map of lifecycle policies to create | <pre>map(object({<br/>    bucket_key         = string<br/>    rule_name          = string<br/>    is_enabled         = optional(bool, true)<br/>    action             = string<br/>    inclusion_prefixes = optional(list(string), [])<br/>    inclusion_patterns = optional(list(string), [])<br/>    target             = string<br/>    time_amount        = number<br/>    time_unit          = string<br/>  }))</pre> | `{}` | no |
| <a name="input_preauth_requests"></a> [preauth\_requests](#input\_preauth\_requests) | Map of pre-authenticated requests to create | <pre>map(object({<br/>    bucket_key   = string<br/>    name         = string<br/>    object       = string<br/>    access_type  = string<br/>    time_expires = string<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region for bucket URIs | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_names"></a> [bucket\_names](#output\_bucket\_names) | Names of the buckets |
| <a name="output_bucket_namespaces"></a> [bucket\_namespaces](#output\_bucket\_namespaces) | Namespaces of the buckets |
| <a name="output_bucket_uris"></a> [bucket\_uris](#output\_bucket\_uris) | URIs of the buckets (format: https://objectstorage.<region>.oraclecloud.com/n/<namespace>/b/<name>/o) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Object Storage namespace |
| <a name="output_preauth_request_uris"></a> [preauth\_request\_uris](#output\_preauth\_request\_uris) | URIs of the pre-authenticated requests |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Object Storage module |
<!-- END_TF_DOCS -->
