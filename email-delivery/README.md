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

## Examples

See the [examples](../examples/email-delivery/) directory for complete examples.
