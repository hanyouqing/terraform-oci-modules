# Block Storage Module

This module creates and manages block volumes in Oracle Cloud Infrastructure, including backups and backup policies.

## Features

- Create multiple block volumes
- Volume backup management
- Backup policy creation and assignment
- Volume attachment to compute instances
- Auto-tune support
- Comprehensive tagging support

## Always Free Limits

- **Total Block Storage**: 200 GB (boot + block volumes combined)
- **Volume Backups**: 5 backups total
- **Minimum Volume Size**: 50 GB
- **Maximum Volume Size**: 200 GB (per volume, but total limit applies)

## Usage

```hcl
module "block_storage" {
  source = "../block-storage"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  volumes = {
    data-volume-1 = {
      display_name        = "data-volume-1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      size_in_gbs         = 50
      vpus_per_gb         = "10"
      is_auto_tune_enabled = false
      backup_policy_id    = null
      backup_type         = "FULL"
      freeform_tags       = {}
      defined_tags        = {}
    }
  }

  create_backups = true

  volume_attachments = {
    data-volume-1-attachment = {
      volume_key      = "data-volume-1"
      instance_id     = module.compute.instance_ids[0]
      attachment_type = "paravirtualized"
      display_name    = "data-volume-1-attachment"
      device          = "/dev/oracleoci/oraclevdb"
      is_read_only    = false
      is_shareable    = false
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
| compartment_id | OCID of the compartment where the block volumes will be created | `string` | n/a | yes |
| tenancy_ocid | OCID of the tenancy | `string` | n/a | yes |
| volumes | Map of block volumes to create | `map(object)` | `{}` | no |
| create_backups | Whether to create backups for volumes | `bool` | `false` | no |
| backup_policies | Map of backup policies to create | `map(object)` | `{}` | no |
| volume_attachments | Map of volume attachments | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| volume_ids | OCIDs of the block volumes |
| backup_ids | OCIDs of the volume backups |
| total_storage_gb | Total storage size in GBs |

## Examples

See the [examples](../examples/block-storage/) directory for complete examples.
