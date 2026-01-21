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

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, volume performance, and backup retention.

### Always Free Tier

The following block storage resources are **free** within Always Free tier limits:
- **Total Block Storage**: 200 GB (boot volumes + block volumes combined)
- **Volume Backups**: 5 backups total
- **Minimum Volume Size**: 50 GB per volume

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Block Volumes** | | |
| Standard Volume (50 GB) | 10 VPUs/GB | ~**$2-3** |
| Standard Volume (100 GB) | 10 VPUs/GB | ~**$4-5** |
| Standard Volume (200 GB) | 10 VPUs/GB | ~**$8-10** |
| Balanced Volume (50 GB) | 20 VPUs/GB | ~**$3-4** |
| Balanced Volume (100 GB) | 20 VPUs/GB | ~**$6-8** |
| High Performance Volume (50 GB) | 30 VPUs/GB | ~**$4-5** |
| High Performance Volume (100 GB) | 30 VPUs/GB | ~**$8-10** |
| **Volume Backups** | | |
| Backup Storage (50 GB) | 1 backup, 30-day retention | ~**$1-2** |
| Backup Storage (100 GB) | 1 backup, 30-day retention | ~**$2-3** |
| Incremental Backup | Per GB changed | ~**$0.01-0.02/GB** |
| **Backup Policies** | | |
| Gold Backup Policy | Daily backups, 30-day retention | Included in backup storage cost |
| Silver Backup Policy | Weekly backups, 30-day retention | Included in backup storage cost |
| **Total (100 GB volume + 1 backup)** | Standard performance | **~$6-8/month** |
| **Total (200 GB volume + daily backups)** | Standard performance | **~$12-15/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 200 GB total (boot + block volumes)
> - VPU (Volume Performance Units) settings affect cost and performance
> - Backup costs depend on backup frequency, retention, and data change rate
> - Auto-tune can optimize performance without manual VPU adjustments
> - To minimize costs, use standard performance (10 VPUs/GB) for non-critical workloads

### Cost Optimization Tips

1. **Use Always Free tier** (200 GB total) when possible
2. **Right-size volumes** to match actual storage needs
3. **Use Standard performance** (10 VPUs/GB) for non-performance-critical workloads
4. **Optimize backup policies** to balance recovery needs with storage costs
5. **Enable auto-tune** to automatically optimize performance
6. **Use incremental backups** to reduce backup storage costs

## Examples

See the [examples](../examples/block-storage/) directory for complete examples.
