# Logging Module

This module creates and manages Logging log groups and logs in Oracle Cloud Infrastructure.

## Features

- Create log groups
- Create logs for various services
- Retention duration configuration
- Comprehensive tagging support

## Always Free Limits

- Logging service is free for Always Free tier accounts

## Usage

```hcl
module "logging" {
  source = "../logging"

  compartment_id = var.compartment_id

  log_groups = {
    app-logs = {
      display_name = "app-logs"
      description  = "Application logs"
    }
  }

  logs = {
    compute-logs = {
      log_group_key     = "app-logs"
      display_name      = "compute-logs"
      log_type          = "SERVICE"
      is_enabled        = true
      retention_duration = 30
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

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, log volume, and retention duration.

### Always Free Tier

The following Logging resources are **free** for Always Free tier accounts:
- **Log Groups**: Unlimited
- **Logs**: Unlimited
- **Log Ingestion**: Free for Always Free tier
- **Log Storage**: Free for Always Free tier

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Log Ingestion** | | |
| Log Ingestion (Always Free) | Free tier accounts | **$0** (Free) |
| Log Ingestion (Paid) | Per GB ingested | ~**$0.50-1/GB** |
| **Log Storage** | | |
| Log Storage (Always Free) | Free tier accounts | **$0** (Free) |
| Log Storage (Paid) | Per GB stored | ~**$0.03-0.05/GB/month** |
| **Log Groups & Logs** | | |
| Log Groups | Unlimited | **$0** (Free) |
| Logs | Unlimited | **$0** (Free) |
| **Total (Always Free tier)** | Any configuration | **$0** (Free) |
| **Total (Paid tier, 100 GB ingestion, 50 GB storage)** | Small production | **~$52.50-105/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes free log ingestion and storage
> - Log groups and logs are free regardless of usage
> - Storage costs depend on retention duration and log volume
> - To minimize costs, use Always Free tier when possible, or optimize log retention

### Cost Optimization Tips

1. **Use Always Free tier** when possible (completely free)
2. **Optimize log retention** to reduce storage costs
3. **Filter unnecessary logs** to reduce ingestion volume
4. **Use log aggregation** to reduce storage requirements
5. **Monitor log volume** to optimize retention policies
6. **Archive old logs** to cheaper storage tiers if available

## Examples

See the [examples](../examples/logging/) directory for complete examples.
