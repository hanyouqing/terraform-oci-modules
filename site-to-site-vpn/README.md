# Site-to-Site VPN Module

This module creates and manages Site-to-Site VPN connections in Oracle Cloud Infrastructure, including Customer-Premises Equipment (CPE) objects and IPSec connections with redundant tunnels.

## Features

- Create CPE objects (on-premises VPN device representation)
- Create IPSec connections with static routing
- Automatic redundant tunnels (2 per connection)
- Tunnel details exported for on-premises CPE configuration
- CPE device shape support for vendor-specific configuration
- Private CPE support for FastConnect integration
- Comprehensive tagging support

## Always Free Limits

- **IPSec Connections**: Up to 50 per tenancy
- **Tunnels**: 2 per connection (100 total)
- **CPE Objects**: Unlimited
- **Data Transfer**: Standard OCI rates apply

## Usage

```hcl
module "vpn" {
  source = "../site-to-site-vpn"

  compartment_id = var.compartment_id

  cpes = {
    on-prem = {
      display_name = "on-premises-firewall"
      ip_address   = "203.0.113.1"
    }
  }

  ipsec_connections = {
    main-vpn = {
      display_name  = "main-site-vpn"
      drg_id        = var.drg_id
      cpe_key       = "on-prem"
      static_routes = ["10.0.0.0/16"]
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Prerequisites

This module requires a Dynamic Routing Gateway (DRG). Use the [vcn module](../vcn/) with `create_drg = true`:

```hcl
module "vcn" {
  source = "../vcn"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  create_drg     = true
  attach_drg     = true
}

# Then reference: drg_id = module.vcn.drg_id
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| oci | ~> 7.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment | `string` | n/a | yes |
| cpes | Map of CPE objects | `map(object)` | `{}` | no |
| ipsec_connections | Map of IPSec connections | `map(object)` | `{}` | no |
| project | Project name for tagging | `string` | `"oci-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| freeform_tags | Freeform tags for all resources | `map(string)` | `{}` | no |
| defined_tags | Defined tags for all resources | `map(map(string))` | `{}` | no |

### CPE Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| display_name | CPE display name | `string` | — |
| ip_address | Public IP of on-premises VPN device | `string` | — |
| cpe_device_shape_id | Vendor/model shape ID | `string` | `null` |
| is_private | Private CPE for FastConnect | `bool` | `false` |

### IPSec Connection Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| display_name | Connection display name | `string` | — |
| drg_id | OCID of the DRG | `string` | — |
| cpe_key | Key in `cpes` variable | `string` | `null` |
| cpe_id | External CPE OCID (if not using cpe_key) | `string` | `null` |
| static_routes | On-premises CIDR blocks (1-10) | `list(string)` | — |
| cpe_local_identifier | CPE local identifier | `string` | `null` |
| cpe_local_identifier_type | IP_ADDRESS or HOSTNAME | `string` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| cpe_ids | OCIDs of the CPE objects |
| cpe_ip_addresses | IP addresses of the CPE objects |
| ipsec_connection_ids | OCIDs of the IPSec connections |
| ipsec_connection_states | States of the connections |
| tunnel_details | Tunnel IDs, VPN IPs, status, routing for each connection |
| tunnel_vpn_ips | Oracle VPN endpoint IPs (for CPE configuration) |

## Tunnel Management

Each IPSec connection automatically creates 2 redundant tunnels. After creation, configure tunnels using `oci_core_ipsec_connection_tunnel_management` for:
- **BGP routing**: Dynamic route exchange with your CPE
- **IKE version**: Upgrade to IKEv2 for stronger security
- **Shared secret**: Custom pre-shared keys
- **Encryption domains**: Policy-based VPN traffic selectors

## Cost Estimate

### Always Free Tier

The following Site-to-Site VPN resources are **free** within Always Free tier limits:
- **50 IPSec Connections**: Each with 2 redundant tunnels
- **CPE Objects**: Unlimited
- **VPN Throughput**: No per-GB VPN charge (standard data transfer rates apply)

### Cost Breakdown

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **IPSec Connections** | Up to 50 | **$0** (Free) |
| **CPE Objects** | Unlimited | **$0** (Free) |
| **Data Transfer (VPN)** | | |
| Inbound | Unlimited | **$0** (Free) |
| Outbound | First 10 TB/month | **$0** (Always Free) |
| Outbound | Beyond 10 TB | ~**$0.0085/GB** |
| **DRG** | Required prerequisite | **$0** (Free) |

> **Notes:**
> - VPN connections and tunnels are free; only data transfer has costs
> - Always Free includes 10 TB/month outbound data transfer
> - Each connection creates 2 tunnels for high availability
> - For high-bandwidth needs, consider FastConnect (dedicated circuit)

### Cost Optimization Tips

1. **Use VPN for dev/test** and low-bandwidth production workloads
2. **Monitor data transfer** to stay within 10 TB/month free tier
3. **Use BGP routing** for automatic failover between tunnels
4. **Consolidate traffic** through fewer connections when possible
5. **Consider FastConnect** for production workloads >1 Gbps

## Examples

- [Basic](examples/basic/) — Single CPE + IPSec connection with static routing
- [Complete](examples/complete/) — Multiple CPEs + IPSec connections for multi-site VPN

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
| [oci_core_cpe.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_cpe) | resource |
| [oci_core_ipsec.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_ipsec) | resource |
| [oci_core_ipsec_connection_tunnels.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_ipsec_connection_tunnels) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where VPN resources will be created | `string` | n/a | yes |
| <a name="input_cpes"></a> [cpes](#input\_cpes) | Map of Customer-Premises Equipment (CPE) objects representing on-premises VPN devices. | <pre>map(object({<br/>    display_name        = string<br/>    ip_address          = string<br/>    cpe_device_shape_id = optional(string, null)<br/>    is_private          = optional(bool, false)<br/>    freeform_tags       = optional(map(string), {})<br/>    defined_tags        = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_ipsec_connections"></a> [ipsec\_connections](#input\_ipsec\_connections) | Map of IPSec connections. Each connection creates 2 redundant tunnels. Always Free: 50 connections per tenancy. Use cpe\_key to reference a CPE in the cpes variable, or cpe\_id for an external CPE OCID. | <pre>map(object({<br/>    display_name  = string<br/>    drg_id        = string<br/>    static_routes = list(string)<br/><br/>    # Reference to a CPE — either a key in cpes variable or a direct OCID<br/>    cpe_key = optional(string, null)<br/>    cpe_id  = optional(string, null)<br/><br/>    cpe_local_identifier      = optional(string, null)<br/>    cpe_local_identifier_type = optional(string, null)<br/><br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cpe_ids"></a> [cpe\_ids](#output\_cpe\_ids) | OCIDs of the Customer-Premises Equipment objects |
| <a name="output_cpe_ip_addresses"></a> [cpe\_ip\_addresses](#output\_cpe\_ip\_addresses) | IP addresses of the CPE objects |
| <a name="output_ipsec_connection_ids"></a> [ipsec\_connection\_ids](#output\_ipsec\_connection\_ids) | OCIDs of the IPSec connections |
| <a name="output_ipsec_connection_states"></a> [ipsec\_connection\_states](#output\_ipsec\_connection\_states) | States of the IPSec connections |
| <a name="output_tunnel_details"></a> [tunnel\_details](#output\_tunnel\_details) | Tunnel details for each IPSec connection (2 tunnels per connection) |
| <a name="output_tunnel_vpn_ips"></a> [tunnel\_vpn\_ips](#output\_tunnel\_vpn\_ips) | Oracle VPN endpoint IPs for each IPSec connection (for on-premises CPE configuration) |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Site-to-Site VPN module |
<!-- END_TF_DOCS -->
