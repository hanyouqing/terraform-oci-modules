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

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, bandwidth, and data transfer volumes.

### Always Free Tier

The following Load Balancer resources are **free** within Always Free tier limits:
- **1 Flexible Load Balancer**: 10 Mbps bandwidth
- **Backend Servers**: Limited by Always Free compute instances (2 E2.1.Micro or 4 OCPUs A1.Flex)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Load Balancer** | | |
| Flexible Shape (10 Mbps) | 1 load balancer, 24/7 | ~**$18-22** |
| Flexible Shape (50 Mbps) | 1 load balancer, 24/7 | ~**$50-60** |
| Flexible Shape (100 Mbps) | 1 load balancer, 24/7 | ~**$90-110** |
| Fixed Shape (100 Mbps) | 1 load balancer, 24/7 | ~**$80-100** |
| **Bandwidth** | | |
| Additional Bandwidth | Per Mbps over included | ~**$0.50-1/Mbps/month** |
| **SSL/TLS Certificates** | | |
| SSL Certificate (BYOC) | Bring Your Own Certificate | **$0** (Free) |
| OCI Managed Certificate | Managed SSL certificate | ~**$5-10/month** |
| **Data Processing** | | |
| Data Processing | 1 TB/month | ~**$0** (included in base cost) |
| **Total (10 Mbps Flexible)** | Always Free tier | **$0** (Free) |
| **Total (50 Mbps Flexible)** | Small production | **~$50-60/month** |
| **Total (100 Mbps Flexible)** | Medium production | **~$90-110/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 1 flexible load balancer with 10 Mbps
> - Bandwidth costs are based on maximum configured bandwidth, not actual usage
> - SSL/TLS termination is included in load balancer cost
> - Data processing charges may apply for very high traffic volumes
> - To minimize costs, use Always Free tier (10 Mbps) when possible, or right-size bandwidth

### Cost Optimization Tips

1. **Use Always Free tier** (10 Mbps flexible) when possible
2. **Right-size bandwidth** to match actual traffic needs
3. **Use flexible shape** for variable traffic patterns
4. **Bring Your Own Certificate (BYOC)** to avoid certificate management fees
5. **Monitor traffic** and adjust bandwidth as needed
6. **Use health checks** to avoid routing traffic to unhealthy backends

## Examples

See the [examples](../examples/load-balancer/) directory for complete examples.
