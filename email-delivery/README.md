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
| [oci_email_sender.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/email_sender) | resource |
| [oci_email_suppression.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/email_suppression) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the email delivery resources will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_senders"></a> [senders](#input\_senders) | Map of email senders to create | <pre>map(object({<br/>    email_address = string<br/>  }))</pre> | `{}` | no |
| <a name="input_suppressions"></a> [suppressions](#input\_suppressions) | Map of email suppressions to create | <pre>map(object({<br/>    email_address = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sender_ids"></a> [sender\_ids](#output\_sender\_ids) | OCIDs of the email senders |
| <a name="output_suppression_ids"></a> [suppression\_ids](#output\_suppression\_ids) | OCIDs of the email suppressions |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Email Delivery module |
<!-- END_TF_DOCS -->
