# Load Balancer Module

This module creates and manages Load Balancers in Oracle Cloud Infrastructure.

## Features

- Create flexible or fixed-shape load balancers
- Backend set configuration
- Backend server management
- Listener configuration
- SSL/TLS support
- Health check configuration
- Network Security Group support
- Comprehensive tagging support

## Always Free Limits

- **Load Balancers**: 1 flexible load balancer
- **Bandwidth**: 10 Mbps
- **Backend Servers**: Limited by Always Free compute instances

## Usage

```hcl
module "load_balancer" {
  source = "../load-balancer"

  compartment_id = var.compartment_id
  display_name   = "my-load-balancer"
  shape          = "flexible"
  subnet_ids     = [module.vcn.public_subnet_ids["public-subnet-1"]]

  shape_details = {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  backend_sets = {
    backend-set-1 = {
      policy = "ROUND_ROBIN"
      health_checker = {
        protocol            = "HTTP"
        port                = 80
        url_path            = "/"
        interval_ms         = 10000
        timeout_in_millis   = 3000
        retries             = 3
        response_body_regex = ".*"
      }
      ssl_configuration = null
    }
  }

  listeners = {
    listener-1 = {
      default_backend_set_name = "backend-set-1"
      port                     = 80
      protocol                 = "HTTP"
      ssl_configuration        = null
      connection_configuration = {
        idle_timeout_in_seconds = 60
      }
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

See the [examples](../examples/load-balancer/) directory for complete examples.
