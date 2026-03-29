# MySQL HeatWave Module

This module creates and manages MySQL HeatWave Database Service systems in Oracle Cloud Infrastructure.

## Features

- Create MySQL HeatWave systems
- Single node configuration for Always Free
- Backup policy configuration
- Comprehensive tagging support

## Always Free Limits

- **System**: 1 single-node system
- **Data Storage**: 50 GB
- **Backup Storage**: 50 GB

Use shape **`MySQL.Free`** for Always Free. Paid shapes (for example `MySQL.HeatWave.VM.Standard.E3.*`) appear in `examples/complete` and are not covered by Always Free.

## Usage

```hcl
module "mysql" {
  source = "../mysql"

  compartment_id = var.compartment_id

  mysql_systems = {
    mysql-1 = {
      display_name        = "mysql-1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      shape_name          = "MySQL.Free"
      subnet_id           = module.vcn.private_subnet_ids["private-subnet-1"]
      admin_username      = "admin"
      admin_password      = var.mysql_password
      mysql_version       = "8.0.35"
      configuration_id    = null
      data_storage_size_in_gb = 50
      backup_policy = {
        is_enabled        = true
        retention_in_days = 7
        window_start_time = "02:00"
      }
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
| oci | ~> 7.30 |

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, instance size, and data transfer volumes.

### Always Free Tier

The following MySQL HeatWave resources are **free** within Always Free tier limits:
- **1 Single-Node System**: MySQL HeatWave instance
- **Data Storage**: 50 GB
- **Backup Storage**: 50 GB

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **MySQL HeatWave Systems** | | |
| Single Node (E3.1.8GB) | 1 instance, 24/7 | ~**$200-250** |
| Single Node (E3.2.16GB) | 1 instance, 24/7 | ~**$400-500** |
| High Availability (2 nodes) | 2 instances, 24/7 | ~**$800-1,000** |
| **Storage** | | |
| Additional Data Storage (100 GB) | Beyond 50 GB included | ~**$20-25** |
| Additional Data Storage (500 GB) | Beyond 50 GB included | ~**$100-125** |
| **Backup Storage** | | |
| Additional Backup Storage (100 GB) | Beyond 50 GB included | ~**$10-15** |
| Backup Storage (500 GB) | 30-day retention | ~**$50-75** |
| **Data Transfer** | | |
| Data Transfer Out | 100 GB/month | ~**$9-10** |
| **Total (1 Single Node + 100 GB additional storage)** | Small production | **~$230-285/month** |
| **Total (1 Single Node + 500 GB additional storage)** | Medium production | **~$310-400/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 1 single-node system with 50 GB data + 50 GB backup storage
> - High Availability configurations require 2+ nodes and are more expensive
> - Backup storage costs depend on retention period and backup frequency
> - Data transfer costs apply to outbound internet traffic
> - To minimize costs, use Always Free tier when possible, or start with single-node configuration

### Cost Optimization Tips

1. **Use Always Free tier** (1 single-node, 50 GB) when possible
2. **Start with single-node** configuration for cost-effective scaling
3. **Right-size storage** to match actual data needs
4. **Optimize backup retention** to balance recovery needs with storage costs
5. **Use Service Gateway** for OCI service access (free, no data transfer charges)
6. **Monitor instance utilization** and scale down when possible

## Examples

See the [examples](../examples/mysql/) directory for complete examples.

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
| [oci_mysql_mysql_db_system.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/mysql_mysql_db_system) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the MySQL system will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (oci\_mysql\_mysql\_db\_system expects map(string)) | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_mysql_systems"></a> [mysql\_systems](#input\_mysql\_systems) | Map of MySQL systems to create. For Always Free, use shape\_name='MySQL.Free' and data\_storage\_size\_in\_gb=50. | <pre>map(object({<br/>    display_name            = string<br/>    availability_domain     = string<br/>    shape_name              = string<br/>    subnet_id               = string<br/>    admin_username          = string<br/>    admin_password          = string<br/>    mysql_version           = optional(string, "8.0.35")<br/>    configuration_id        = optional(string, null)<br/>    data_storage_size_in_gb = number<br/>    backup_policy = object({<br/>      is_enabled        = optional(bool, true)<br/>      retention_in_days = optional(number, 7)<br/>      window_start_time = optional(string, "02:00")<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_endpoints"></a> [mysql\_endpoints](#output\_mysql\_endpoints) | Endpoints of the MySQL systems |
| <a name="output_mysql_system_ids"></a> [mysql\_system\_ids](#output\_mysql\_system\_ids) | OCIDs of the MySQL systems |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for MySQL module |
<!-- END_TF_DOCS -->
