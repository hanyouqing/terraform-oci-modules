# Email Delivery Module

This module creates and manages Email Delivery senders and suppressions in Oracle Cloud Infrastructure.

## Features

- Create email senders
- Manage email suppressions
- Comprehensive tagging support

## Always Free Limits

- **Emails**: 3,000 per month

## Usage

```hcl
module "email_delivery" {
  source = "../email-delivery"

  compartment_id = var.compartment_id

  senders = {
    sender-1 = {
      email_address = "noreply@example.com"
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

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region and email volume.

### Always Free Tier

The following Email Delivery resources are **free** within Always Free tier limits:
- **Emails**: 3,000 per month
- **Senders**: Unlimited
- **Suppressions**: Unlimited

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Email Delivery** | | |
| Emails (0-3K) | First 3,000 emails | **$0** (Free) |
| Emails (3K-10K) | Additional emails | ~**$0.10-0.15/thousand** |
| Emails (10K-100K) | Bulk pricing | ~**$0.05-0.10/thousand** |
| Emails (100K+) | Enterprise pricing | ~**$0.02-0.05/thousand** |
| **Senders & Suppressions** | | |
| Senders | Unlimited | **$0** (Free) |
| Suppressions | Unlimited | **$0** (Free) |
| **Total (5K emails)** | Small production | **~$0.20-0.30/month** |
| **Total (50K emails)** | Medium production | **~$2.50-5/month** |
| **Total (500K emails)** | Large production | **~$10-25/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 3,000 emails per month
> - Senders and suppressions are free regardless of usage
> - Email costs are based on delivery attempts, not successful deliveries
> - To minimize costs, optimize email frequency and use Always Free tier when possible

### Cost Optimization Tips

1. **Use Always Free tier** (3,000 emails) when possible
2. **Optimize email frequency** to reduce volume
3. **Use email suppressions** to avoid sending to invalid addresses
4. **Monitor email usage** to stay within Always Free tier
5. **Batch emails** when possible to reduce per-email overhead
6. **Use transactional email best practices** to improve deliverability

## Examples

See the [examples](../examples/email-delivery/) directory for complete examples.
