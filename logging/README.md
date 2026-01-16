# Logging Module

This module creates and manages Logging log groups and logs in Oracle Cloud Infrastructure.

## Features

- Create log groups
- Create logs for various services
- Retention duration configuration
- Comprehensive tagging support

## Always Free Limits

- Logging service is free for Always Free tier accounts

## Usage

```hcl
module "logging" {
  source = "../logging"

  compartment_id = var.compartment_id

  log_groups = {
    app-logs = {
      display_name = "app-logs"
      description  = "Application logs"
    }
  }

  logs = {
    compute-logs = {
      log_group_key     = "app-logs"
      display_name      = "compute-logs"
      log_type          = "SERVICE"
      is_enabled        = true
      retention_duration = 30
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

See the [examples](../examples/logging/) directory for complete examples.
