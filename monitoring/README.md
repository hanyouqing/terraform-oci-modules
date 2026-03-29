# Monitoring Module

This module creates and manages Monitoring alarms in Oracle Cloud Infrastructure.

## Features

- Create monitoring alarms
- Metric-based alerting
- Notification integration
- Comprehensive tagging support

## Always Free Limits

- **Ingestion Data Points**: 500 million per month
- **Retrieval Data Points**: 1 billion per month

## Usage

```hcl
module "monitoring" {
  source = "../monitoring"

  compartment_id = var.compartment_id

  alarms = {
    cpu-alarm = {
      display_name          = "High CPU Usage"
      is_enabled            = true
      metric_compartment_id = var.compartment_id
      namespace             = "oci_computeagent"
      query                 = "CpuUtilization[1m].mean() > 80"
      severity              = "CRITICAL"
      message_format        = "ONS_OPTIMIZED"
      body                  = "CPU usage is above 80%"
      destinations          = [[oci_ons_notification_topic.this.id]]
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

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, data ingestion volume, and retrieval patterns.

### Always Free Tier

The following Monitoring resources are **free** within Always Free tier limits:
- **Ingestion Data Points**: 500 million per month
- **Retrieval Data Points**: 1 billion per month
- **Alarms**: Unlimited

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Data Ingestion** | | |
| Ingestion (0-500M points) | First 500 million points | **$0** (Free) |
| Ingestion (500M-1B points) | Additional points | ~**$0.10-0.15/million points** |
| Ingestion (1B+ points) | Bulk pricing | ~**$0.05-0.10/million points** |
| **Data Retrieval** | | |
| Retrieval (0-1B points) | First 1 billion points | **$0** (Free) |
| Retrieval (1B+ points) | Additional points | ~**$0.01-0.02/million points** |
| **Alarms** | | |
| Monitoring Alarms | Unlimited alarms | **$0** (Free) |
| **Total (600M ingestion + 1.2B retrieval)** | Small production | **~$10-15/month** |
| **Total (2B ingestion + 3B retrieval)** | Medium production | **~$150-200/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 500M ingestion and 1B retrieval data points
> - Data points are counted per metric per time interval
> - Alarms are free regardless of usage
> - To minimize costs, optimize metric collection frequency and reduce unnecessary metrics

### Cost Optimization Tips

1. **Use Always Free tier** (500M ingestion, 1B retrieval) when possible
2. **Optimize metric collection frequency** to reduce data points
3. **Filter unnecessary metrics** to reduce ingestion volume
4. **Use metric aggregation** to reduce data point count
5. **Monitor data point usage** to stay within Always Free tier
6. **Archive old metrics** to reduce retrieval costs

## Examples

See the [examples](../examples/monitoring/) directory for complete examples.

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
| [oci_monitoring_alarm.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/monitoring_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | Map of monitoring alarms to create | <pre>map(object({<br/>    display_name          = string<br/>    is_enabled            = optional(bool, true)<br/>    metric_compartment_id = string<br/>    namespace             = string<br/>    query                 = string<br/>    severity              = string<br/>    message_format        = optional(string, "ONS_OPTIMIZED")<br/>    body                  = optional(string, "")<br/>    destinations          = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the monitoring alarms will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_ids"></a> [alarm\_ids](#output\_alarm\_ids) | OCIDs of the monitoring alarms |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Monitoring module |
<!-- END_TF_DOCS -->
