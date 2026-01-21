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
