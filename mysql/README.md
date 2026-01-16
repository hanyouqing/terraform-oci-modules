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

## Examples

See the [examples](../examples/mysql/) directory for complete examples.
