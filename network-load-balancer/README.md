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
| [oci_network_load_balancer_backend.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend_set.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend_set) | resource |
| [oci_network_load_balancer_listener.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_listener) | resource |
| [oci_network_load_balancer_network_load_balancer.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_network_load_balancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_sets"></a> [backend\_sets](#input\_backend\_sets) | Map of backend set configurations. Policy options: FIVE\_TUPLE, THREE\_TUPLE, TWO\_TUPLE. | <pre>map(object({<br/>    policy                    = string<br/>    is_fail_open              = optional(bool, false)<br/>    is_instant_failover       = optional(bool, false)<br/>    is_preserve_source        = optional(bool, false)<br/>    ip_version                = optional(string, "IPV4")<br/>    are_operationally_grouped = optional(bool, false)<br/>    health_checker = object({<br/>      protocol            = string<br/>      port                = optional(number, 0)<br/>      interval_in_millis  = optional(number, 10000)<br/>      timeout_in_millis   = optional(number, 3000)<br/>      retries             = optional(number, 3)<br/>      url_path            = optional(string, "/")<br/>      return_code         = optional(number, 200)<br/>      request_data        = optional(string)<br/>      response_data       = optional(string)<br/>      response_body_regex = optional(string)<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map of backend server configurations. | <pre>map(object({<br/>    backend_set_name = string<br/>    ip_address       = optional(string)<br/>    target_id        = optional(string)<br/>    port             = number<br/>    is_backup        = optional(bool, false)<br/>    is_drain         = optional(bool, false)<br/>    is_offline       = optional(bool, false)<br/>    weight           = optional(number, 1)<br/>  }))</pre> | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment to create the Network Load Balancer in. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | A user-friendly display name for the Network Load Balancer. | `string` | `"network-load-balancer"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., development, staging, production). | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Free-form tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_is_preserve_source_destination"></a> [is\_preserve\_source\_destination](#input\_is\_preserve\_source\_destination) | If true, preserves source and destination IP headers. Required for transparent routing. | `bool` | `false` | no |
| <a name="input_is_private"></a> [is\_private](#input\_is\_private) | Whether the NLB has a public or private IP address. Set to true for internal NLB. | `bool` | `true` | no |
| <a name="input_is_symmetric_hash_enabled"></a> [is\_symmetric\_hash\_enabled](#input\_is\_symmetric\_hash\_enabled) | If true, ensures that flows in both directions use the same backend server. | `bool` | `false` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Map of listener configurations. Protocol options: TCP, UDP, TCP\_AND\_UDP. | <pre>map(object({<br/>    default_backend_set_name = string<br/>    port                     = number<br/>    protocol                 = string<br/>    ip_version               = optional(string, "IPV4")<br/>    is_ppv2enabled           = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | List of Network Security Group OCIDs to associate with the NLB. | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name used for tagging and naming. | `string` | `"oci-modules"` | no |
| <a name="input_reserved_ips"></a> [reserved\_ips](#input\_reserved\_ips) | List of reserved public IP OCIDs to assign to the NLB. | <pre>list(object({<br/>    id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The OCID of the subnet to place the Network Load Balancer in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_ids"></a> [backend\_ids](#output\_backend\_ids) | Map of backend names to their composite IDs. |
| <a name="output_backend_set_ids"></a> [backend\_set\_ids](#output\_backend\_set\_ids) | Map of backend set names to their composite IDs. |
| <a name="output_backend_set_names"></a> [backend\_set\_names](#output\_backend\_set\_names) | List of backend set names. |
| <a name="output_listener_names"></a> [listener\_names](#output\_listener\_names) | List of listener names. |
| <a name="output_network_load_balancer_id"></a> [network\_load\_balancer\_id](#output\_network\_load\_balancer\_id) | The OCID of the Network Load Balancer. |
| <a name="output_network_load_balancer_ip_address"></a> [network\_load\_balancer\_ip\_address](#output\_network\_load\_balancer\_ip\_address) | The primary IP address of the Network Load Balancer. |
| <a name="output_network_load_balancer_ip_addresses"></a> [network\_load\_balancer\_ip\_addresses](#output\_network\_load\_balancer\_ip\_addresses) | The IP addresses associated with the Network Load Balancer. |
| <a name="output_network_load_balancer_state"></a> [network\_load\_balancer\_state](#output\_network\_load\_balancer\_state) | The current lifecycle state of the Network Load Balancer. |
| <a name="output_network_load_balancer_time_created"></a> [network\_load\_balancer\_time\_created](#output\_network\_load\_balancer\_time\_created) | The date and time the Network Load Balancer was created. |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Helpful reminders and next steps for Network Load Balancer management. |
<!-- END_TF_DOCS -->
