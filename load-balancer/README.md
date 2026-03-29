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
| [oci_load_balancer_backend.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend_set.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_listener.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_listener) | resource |
| [oci_load_balancer_load_balancer.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_load_balancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_sets"></a> [backend\_sets](#input\_backend\_sets) | Map of backend sets to create | <pre>map(object({<br/>    policy = string<br/>    health_checker = object({<br/>      protocol            = string<br/>      port                = number<br/>      url_path            = string<br/>      interval_ms         = number<br/>      timeout_in_millis   = number<br/>      retries             = number<br/>      response_body_regex = string<br/>    })<br/>    ssl_configuration = optional(object({<br/>      certificate_ids                   = optional(list(string), [])<br/>      certificate_name                  = optional(string, "")<br/>      verify_depth                      = optional(number, 1)<br/>      verify_peer_certificate           = optional(bool, false)<br/>      protocols                         = optional(list(string), [])<br/>      cipher_suite_name                 = optional(string, "")<br/>      server_order_preference           = optional(string, "")<br/>      trusted_certificate_authority_ids = optional(list(string), [])<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map of backends to create | <pre>map(object({<br/>    backendset_name = string<br/>    ip_address      = string<br/>    port            = number<br/>    backup          = bool<br/>    drain           = bool<br/>    offline         = bool<br/>    weight          = number<br/>  }))</pre> | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the load balancer will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (load balancer expects map(string)) | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the load balancer | `string` | `"load-balancer"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_is_private"></a> [is\_private](#input\_is\_private) | Whether the load balancer is private. Recommended to keep private for internal services. | `bool` | `true` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Map of listeners to create. connection\_configuration.idle\_timeout\_in\_seconds defaults to 60 (1-300) | <pre>map(object({<br/>    default_backend_set_name = string<br/>    port                     = number<br/>    protocol                 = string<br/>    ssl_configuration = optional(object({<br/>      certificate_ids                   = optional(list(string), [])<br/>      certificate_name                  = optional(string, "")<br/>      verify_depth                      = optional(number, 1)<br/>      verify_peer_certificate           = optional(bool, false)<br/>      protocols                         = optional(list(string), [])<br/>      cipher_suite_name                 = optional(string, "")<br/>      server_order_preference           = optional(string, "")<br/>      trusted_certificate_authority_ids = optional(list(string), [])<br/>    }))<br/>    connection_configuration = optional(object({<br/>      idle_timeout_in_seconds = number<br/>    }), { idle_timeout_in_seconds = 60 })<br/>  }))</pre> | `{}` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | List of Network Security Group OCIDs | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | Shape of the load balancer. For Always Free, use 'flexible' | `string` | `"flexible"` | no |
| <a name="input_shape_details"></a> [shape\_details](#input\_shape\_details) | Shape details for flexible load balancer. Always Free limit is 10 Mbps. | <pre>object({<br/>    minimum_bandwidth_in_mbps = number<br/>    maximum_bandwidth_in_mbps = number<br/>  })</pre> | <pre>{<br/>  "maximum_bandwidth_in_mbps": 10,<br/>  "minimum_bandwidth_in_mbps": 10<br/>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet OCIDs for the load balancer | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_set_names"></a> [backend\_set\_names](#output\_backend\_set\_names) | Names of the backend sets |
| <a name="output_listener_names"></a> [listener\_names](#output\_listener\_names) | Names of the listeners |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | OCID of the load balancer |
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | Primary IP address of the load balancer |
| <a name="output_load_balancer_ip_addresses"></a> [load\_balancer\_ip\_addresses](#output\_load\_balancer\_ip\_addresses) | IP addresses of the load balancer |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Load Balancer module |
<!-- END_TF_DOCS -->
