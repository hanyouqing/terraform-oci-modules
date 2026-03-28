# APM Module

This module creates and manages Application Performance Monitoring (APM) domains and Synthetics monitors in Oracle Cloud Infrastructure.

## Features

- Create APM domains (Always Free and paid tiers)
- Create Synthetics monitors (REST, Browser, Scripted, Network, DNS, FTP)
- Configurable vantage points for distributed monitoring
- Script parameters for scripted monitors
- Failure retry and batch interval settings
- Comprehensive tagging support

## Always Free Limits

- **Tracing Events**: 1,000 per hour
- **Synthetic Monitor Runs**: 10 per hour
- **APM Domains**: 1 free-tier domain

## Usage

```hcl
module "apm" {
  source = "../apm"

  compartment_id = var.compartment_id

  apm_domains = {
    main = {
      display_name = "my-apm-domain"
      is_free_tier = true
    }
  }

  synthetics_monitors = {
    health-check = {
      display_name               = "app-health-check"
      apm_domain_key             = "main"
      monitor_type               = "REST"
      repeat_interval_in_seconds = 360
      target                     = "https://app.example.com/health"
      vantage_points             = ["OraclePublic-us-ashburn-1"]
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
| oci | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| oci | ~> 7.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment | `string` | n/a | yes |
| apm_domains | Map of APM domains to create | `map(object)` | `{}` | no |
| synthetics_monitors | Map of Synthetics monitors | `map(object)` | `{}` | no |
| project | Project name for tagging | `string` | `"oci-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| freeform_tags | Freeform tags for all resources | `map(string)` | `{}` | no |
| defined_tags | Defined tags for all resources | `map(map(string))` | `{}` | no |

### APM Domain Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| display_name | Domain display name | `string` | — |
| description | Domain description | `string` | `""` |
| is_free_tier | Always Free domain | `bool` | `true` |

### Synthetics Monitor Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| display_name | Monitor display name | `string` | — |
| monitor_type | SCRIPTED_BROWSER, BROWSER, SCRIPTED_REST, REST, NETWORK, DNS, FTP | `string` | — |
| repeat_interval_in_seconds | Run interval (360 = 10/hour for free tier) | `number` | — |
| apm_domain_key | Key in `apm_domains` map | `string` | `null` |
| apm_domain_id | External APM domain OCID | `string` | `null` |
| target | URL or endpoint to monitor | `string` | `null` |
| status | ENABLED or DISABLED | `string` | `"ENABLED"` |
| vantage_points | List of vantage point names | `list(string)` | `[]` |
| timeout_in_seconds | Request timeout | `number` | `60` |
| is_failure_retried | Retry on failure | `bool` | `true` |

## Outputs

| Name | Description |
|------|-------------|
| apm_domain_ids | OCIDs of the APM domains |
| apm_domain_data_upload_endpoints | Data upload endpoints (for APM agents) |
| apm_domain_states | Lifecycle states of the domains |
| synthetics_monitor_ids | OCIDs of the monitors |
| synthetics_monitor_statuses | Statuses of the monitors |

## Cost Estimate

### Always Free Tier

The following APM resources are **free** within Always Free tier limits:
- **1 APM Domain** (free tier enabled)
- **1,000 Tracing Events/Hour** (distributed tracing)
- **10 Synthetic Monitor Runs/Hour** (= 1 run every 360 seconds)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **APM Domain** | | |
| Free Tier | 1,000 events/hour | **$0** (Free) |
| Standard | Up to 100M events/hour | ~**$0.02/1K events** |
| **Synthetics** | | |
| Free Tier Runs | 10 runs/hour | **$0** (Free) |
| Additional Runs | Per 1K runs | ~**$2.00** |
| **Data Storage** | | |
| Trace Data | Included for 14 days | **$0** (Free) |
| Extended Retention | Per GB/month | ~**$0.25** |

> **Notes:**
> - Free tier is limited to 1 APM domain with `is_free_tier = true`
> - Tracing events include spans from APM agents
> - Synthetics pricing is per execution, not per monitor
> - Vantage point selection does not affect pricing

### Cost Optimization Tips

1. **Use Always Free tier** for development and testing
2. **Set repeat_interval to 360s** (10 runs/hour) for free-tier Synthetics
3. **Use sampling** in APM agents to reduce tracing event volume
4. **Monitor only critical endpoints** with Synthetics in free tier
5. **Use REST monitors** (lightweight) instead of Browser monitors when possible

## Examples

- [Basic](examples/basic/) — Single Always Free APM domain
- [Complete](examples/complete/) — APM domain with multiple Synthetics monitors
