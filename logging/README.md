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
| [oci_logging_log.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/logging_log) | resource |
| [oci_logging_log_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/logging_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the logging resources will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_log_groups"></a> [log\_groups](#input\_log\_groups) | Map of log groups to create | <pre>map(object({<br/>    display_name = string<br/>    description  = string<br/>  }))</pre> | `{}` | no |
| <a name="input_logs"></a> [logs](#input\_logs) | Map of logs to create | <pre>map(object({<br/>    log_group_key      = string<br/>    display_name       = string<br/>    log_type           = string<br/>    is_enabled         = bool<br/>    retention_duration = number<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_ids"></a> [log\_group\_ids](#output\_log\_group\_ids) | OCIDs of the log groups |
| <a name="output_log_ids"></a> [log\_ids](#output\_log\_ids) | OCIDs of the logs |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Logging module |
<!-- END_TF_DOCS -->
