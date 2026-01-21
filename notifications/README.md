# Notifications Module

This module creates and manages Notification Service topics and subscriptions in Oracle Cloud Infrastructure.

## Features

- Create notification topics
- Create subscriptions (HTTPS, Email, etc.)
- Comprehensive tagging support

## Always Free Limits

- **HTTPS Notifications**: 1 million per month
- **Email Notifications**: 1,000 per month

## Usage

```hcl
module "notifications" {
  source = "../notifications"

  compartment_id = var.compartment_id

  topics = {
    alerts = {
      name        = "alerts"
      description = "Alert notifications"
    }
  }

  subscriptions = {
    email-subscription = {
      topic_key = "alerts"
      protocol  = "EMAIL"
      endpoint  = "admin@example.com"
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

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region and notification volume.

### Always Free Tier

The following Notification Service resources are **free** within Always Free tier limits:
- **HTTPS Notifications**: 1 million per month
- **Email Notifications**: 1,000 per month
- **Topics**: Unlimited
- **Subscriptions**: Unlimited

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Notifications** | | |
| HTTPS (0-1M) | First 1 million notifications | **$0** (Free) |
| HTTPS (1M-10M) | Additional notifications | ~**$0.10-0.15/thousand** |
| HTTPS (10M+) | Bulk pricing | ~**$0.05-0.10/thousand** |
| Email (0-1K) | First 1,000 emails | **$0** (Free) |
| Email (1K-10K) | Additional emails | ~**$0.10-0.15/thousand** |
| Email (10K+) | Bulk pricing | ~**$0.05-0.10/thousand** |
| **Topics & Subscriptions** | | |
| Topics | Unlimited | **$0** (Free) |
| Subscriptions | Unlimited | **$0** (Free) |
| **Total (2M HTTPS + 2K Email)** | Small production | **~$200-300/month** |
| **Total (10M HTTPS + 5K Email)** | Medium production | **~$1,000-1,500/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 1M HTTPS and 1K email notifications
> - Topics and subscriptions are free regardless of usage
> - Notification costs are based on delivery attempts, not successful deliveries
> - To minimize costs, optimize notification frequency and use HTTPS when possible

### Cost Optimization Tips

1. **Use Always Free tier** (1M HTTPS, 1K email) when possible
2. **Optimize notification frequency** to reduce volume
3. **Use HTTPS subscriptions** instead of email when possible (higher free tier)
4. **Batch notifications** to reduce per-notification overhead
5. **Monitor notification usage** to stay within Always Free tier
6. **Use webhook endpoints** for high-volume scenarios

## Examples

See the [examples](../examples/notifications/) directory for complete examples.
