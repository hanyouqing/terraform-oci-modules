# Autonomous Database Module

This module creates and manages Oracle Autonomous Databases in Oracle Cloud Infrastructure.

## Features

- Create Autonomous Databases (Shared or Dedicated)
- Support for Always Free tier
- Automatic scaling configuration
- Private endpoint support
- mTLS connection configuration
- Network Security Group support
- Comprehensive tagging support

## Always Free Limits

- **Instances**: Up to 2 Autonomous Database instances
- **CPU**: 1 OCPU per instance
- **Storage**: 20 GB per instance (1 TB in Terraform units)
- **Workload Types**: ATP (Autonomous Transaction Processing) or ADW (Autonomous Data Warehouse)

## Usage

```hcl
module "autonomous_database" {
  source = "../autonomous-database"

  compartment_id = var.compartment_id

  databases = {
    adb-1 = {
      db_name                  = "mydb"
      display_name             = "My Autonomous Database"
      admin_password           = var.admin_password
      db_workload              = "OLTP"
      is_free_tier             = true
      license_model            = "LICENSE_INCLUDED"
      cpu_core_count           = 1
      data_storage_size_in_tbs = 1
      is_auto_scaling_enabled  = false
      is_dedicated             = false
      is_mtls_connection_required = false
      is_preview_version_with_service_terms_accepted = false
      nsg_ids                  = []
      private_endpoint_label   = null
      subnet_id                = null
      vcn_id                   = null
      whitelisted_ips          = ["0.0.0.0/0"]
      freeform_tags            = {}
      defined_tags             = {}
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
| compartment_id | OCID of the compartment where the Autonomous Database will be created | `string` | n/a | yes |
| databases | Map of Autonomous Databases to create | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| database_ids | OCIDs of the Autonomous Databases |
| database_connection_strings | Connection strings for the Autonomous Databases |
| database_connection_urls | Connection URLs for the Autonomous Databases |

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, workload type, and data transfer volumes.

### Always Free Tier

The following Autonomous Database resources are **free** within Always Free tier limits:
- **2 Autonomous Database Instances**: 1 OCPU + 20 GB storage each
- **Workload Types**: ATP (Autonomous Transaction Processing) or ADW (Autonomous Data Warehouse)
- **License**: Included (License Included model)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Autonomous Database** | | |
| Shared (1 OCPU, 20 GB) | 1 instance, ATP/ADW | ~**$300-350** |
| Shared (2 OCPUs, 40 GB) | 1 instance, ATP/ADW | ~**$600-700** |
| Shared (4 OCPUs, 80 GB) | 1 instance, ATP/ADW | ~**$1,200-1,400** |
| Dedicated (1 OCPU, 20 GB) | 1 instance, ATP/ADW | ~**$1,500-1,800** |
| Dedicated (2 OCPUs, 40 GB) | 1 instance, ATP/ADW | ~**$3,000-3,600** |
| **Storage** | | |
| Additional Storage (100 GB) | Beyond included storage | ~**$20-25** |
| Additional Storage (500 GB) | Beyond included storage | ~**$100-125** |
| **Backup Storage** | | |
| Backup Storage (100 GB) | 30-day retention | ~**$10-15** |
| **Data Transfer** | | |
| Data Transfer Out | 100 GB/month | ~**$9-10** |
| **Total (1 OCPU Shared + 100 GB additional storage)** | Small production | **~$330-385/month** |
| **Total (2 OCPUs Shared + 500 GB additional storage)** | Medium production | **~$710-835/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 2 instances (1 OCPU + 20 GB each)
> - Shared infrastructure is more cost-effective than Dedicated
> - Auto-scaling can help optimize costs based on actual workload
> - Storage costs are separate from compute costs
> - Backup storage costs depend on retention period and backup frequency
> - To minimize costs, use Always Free tier when possible, or start with Shared 1 OCPU

### Cost Optimization Tips

1. **Use Always Free tier** (2 instances, 1 OCPU each) when possible
2. **Start with Shared infrastructure** for cost-effective scaling
3. **Enable auto-scaling** to automatically adjust resources based on workload
4. **Right-size storage** to match actual data needs
5. **Optimize backup retention** to balance recovery needs with storage costs
6. **Use Service Gateway** for OCI service access (free, no data transfer charges)

## Examples

See the [examples](../examples/autonomous-database/) directory for complete examples.

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
| [oci_database_autonomous_database.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_autonomous_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the Autonomous Database will be created | `string` | n/a | yes |
| <a name="input_databases"></a> [databases](#input\_databases) | Map of Autonomous Databases to create. For Always Free, is\_free\_tier=true, cpu\_core\_count=1, data\_storage\_size\_in\_tbs=1. | <pre>map(object({<br/>    db_name                                        = string<br/>    display_name                                   = string<br/>    admin_password                                 = string<br/>    db_workload                                    = string<br/>    is_free_tier                                   = bool<br/>    license_model                                  = string<br/>    cpu_core_count                                 = number<br/>    data_storage_size_in_tbs                       = number<br/>    is_auto_scaling_enabled                        = optional(bool, false)<br/>    is_dedicated                                   = optional(bool, false)<br/>    is_mtls_connection_required                    = optional(bool, true)<br/>    is_preview_version_with_service_terms_accepted = optional(bool, false)<br/>    nsg_ids                                        = optional(list(string), [])<br/>    private_endpoint_label                         = optional(string, null)<br/>    subnet_id                                      = optional(string, null)<br/>    whitelisted_ips                                = optional(list(string), [])<br/>    freeform_tags                                  = optional(map(string), {})<br/>    defined_tags                                   = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_connection_strings"></a> [database\_connection\_strings](#output\_database\_connection\_strings) | Connection strings for the Autonomous Databases |
| <a name="output_database_connection_urls"></a> [database\_connection\_urls](#output\_database\_connection\_urls) | Connection URLs for the Autonomous Databases |
| <a name="output_database_ids"></a> [database\_ids](#output\_database\_ids) | OCIDs of the Autonomous Databases |
| <a name="output_database_private_endpoints"></a> [database\_private\_endpoints](#output\_database\_private\_endpoints) | Private endpoints for the Autonomous Databases |
| <a name="output_database_public_endpoints"></a> [database\_public\_endpoints](#output\_database\_public\_endpoints) | Public endpoints for the Autonomous Databases |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Autonomous Database module |
<!-- END_TF_DOCS -->
