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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 7.30 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_ons_notification_topic.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/ons_notification_topic) | resource |
| [oci_ons_subscription.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/ons_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the notification resources will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Map of subscriptions to create | <pre>map(object({<br/>    topic_key = string<br/>    protocol  = string<br/>    endpoint  = string<br/>  }))</pre> | `{}` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | Map of notification topics to create | <pre>map(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_ids"></a> [subscription\_ids](#output\_subscription\_ids) | OCIDs of the subscriptions |
| <a name="output_topic_endpoints"></a> [topic\_endpoints](#output\_topic\_endpoints) | Endpoints of the notification topics |
| <a name="output_topic_ids"></a> [topic\_ids](#output\_topic\_ids) | OCIDs of the notification topics |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Notifications module |
<!-- END_TF_DOCS -->
