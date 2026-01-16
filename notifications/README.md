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

## Examples

See the [examples](../examples/notifications/) directory for complete examples.
