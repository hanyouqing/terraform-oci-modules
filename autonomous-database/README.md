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
