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

## Examples

See the [examples](../examples/monitoring/) directory for complete examples.
