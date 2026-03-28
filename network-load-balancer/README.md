# OCI Network Load Balancer Module

Manages an OCI Network Load Balancer (NLB) with backend sets, backends, listeners, and health checks. Operates at **Layer 4** (TCP/UDP) for high-performance, low-latency traffic distribution.

## Features

- **Layer 4 Load Balancing**: TCP, UDP, and TCP_AND_UDP protocol support
- **Flexible Policies**: FIVE_TUPLE, THREE_TUPLE, TWO_TUPLE load balancing algorithms
- **Health Checks**: TCP, UDP, HTTP, HTTPS, and DNS health check protocols
- **Source Preservation**: Optional source/destination IP header preservation
- **Symmetric Hashing**: Ensures bidirectional flows use the same backend
- **Reserved IPs**: Assign pre-allocated public IP addresses
- **NSG Integration**: Network Security Group association for access control
- **Proxy Protocol v2**: Optional PPv2 header injection for listeners
- **Always Free Compatible**: 1 NLB instance included in OCI Always Free tier

## Always Free Limits

| Resource | Limit | Notes |
|----------|-------|-------|
| Network Load Balancer | 1 instance | Per tenancy, any region |
| Backend Sets | Unlimited | No additional charge |
| Backends | Unlimited | No additional charge |
| Listeners | Unlimited | No additional charge |
| Bandwidth | Auto-scaling | No shape/bandwidth configuration needed |

## Layer 4 vs Layer 7

| Feature | Network LB (this module) | Load Balancer |
|---------|-------------------------|---------------|
| OSI Layer | Layer 4 (TCP/UDP) | Layer 7 (HTTP/HTTPS) |
| SSL Termination | No (pass-through) | Yes |
| URL Routing | No | Yes |
| Latency | Lower | Higher |
| Bandwidth | Auto-scaling | Configurable shape |
| Always Free | 1 instance | 1 instance (10 Mbps) |

## Usage

```hcl
module "network_load_balancer" {
  source = "github.com/hanyouqing/terraform-oci-modules//network-load-balancer"

  compartment_id = var.compartment_id
  subnet_id      = var.public_subnet_id
  display_name   = "my-nlb"
  is_private     = false

  backend_sets = {
    tcp-backend = {
      policy = "FIVE_TUPLE"
      health_checker = {
        protocol           = "TCP"
        port               = 80
        interval_in_millis = 10000
        timeout_in_millis  = 3000
        retries            = 3
      }
    }
  }

  backends = {
    server-1 = {
      backend_set_name = "tcp-backend"
      ip_address       = "10.0.10.10"
      port             = 80
    }
  }

  listeners = {
    tcp-listener = {
      default_backend_set_name = "tcp-backend"
      port                     = 80
      protocol                 = "TCP"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |

## Cost Estimate

| Resource | Configuration | Estimated Monthly Cost |
|----------|--------------|----------------------|
| Network Load Balancer | 1 instance (Always Free) | $0.00 |
| Network Load Balancer | Additional instances | ~$0.0125/hour (~$9/month) |
| Data Processing | Per GB processed | ~$0.006/GB |

## Cost Optimization Tips

- Use the Always Free NLB for development and small workloads
- NLB has no bandwidth shape — no need to size for peak traffic
- Use TCP health checks to minimize backend overhead
- Consolidate services behind a single NLB with multiple listeners

## Examples

- [Basic](examples/basic/) — Single TCP listener, Always Free compatible
- [Complete](examples/complete/) — Multiple protocols, backends, and health check types

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
