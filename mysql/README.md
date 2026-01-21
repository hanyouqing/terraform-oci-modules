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

## Usage

```hcl
module "mysql" {
  source = "../mysql"

  compartment_id = var.compartment_id

  mysql_systems = {
    mysql-1 = {
      display_name        = "mysql-1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      shape_name          = "MySQL.HeatWave.VM.Standard.E3.1.8GB"
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
| oci | ~> 6.0 |

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
