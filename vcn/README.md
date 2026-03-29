# VCN Module

This module creates a Virtual Cloud Network (VCN) in Oracle Cloud Infrastructure with public and private subnets, Internet Gateway, NAT Gateway, Service Gateway, route tables, and security lists.

## Features

- Create VCN with customizable CIDR blocks
- Create public and private subnets
- Internet Gateway for public subnets
- NAT Gateway for private subnets (optional)
- Service Gateway for OCI services (optional)
- Route tables for public and private subnets
- Security lists (Locked down by default for security)
- Support for IPv6 (optional)
- Comprehensive tagging support

## Usage

```hcl
module "vcn" {
  source = "../vcn"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  vcn_display_name = "my-vcn"
  vcn_cidr_blocks  = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true

  public_subnets = {
    public-subnet-1 = {
      cidr_block          = "10.0.1.0/24"
      display_name        = "public-subnet-1"
      dns_label           = "public1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      security_list_ids   = null
    }
  }

  private_subnets = {
    private-subnet-1 = {
      cidr_block          = "10.0.2.0/24"
      display_name        = "private-subnet-1"
      dns_label           = "private1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      security_list_ids   = null
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

## Providers

| Name | Version |
|------|---------|
| oci | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment where the VCN will be created | `string` | n/a | yes |
| tenancy_ocid | OCID of the tenancy | `string` | n/a | yes |
| vcn_display_name | Display name for the VCN | `string` | `"vcn"` | no |
| vcn_cidr_blocks | List of CIDR blocks for the VCN | `list(string)` | `["10.0.0.0/16"]` | no |
| vcn_dns_label | DNS label for the VCN | `string` | `null` | no |
| enable_ipv6 | Enable IPv6 for the VCN | `bool` | `false` | no |
| create_internet_gateway | Whether to create an Internet Gateway | `bool` | `true` | no |
| internet_gateway_display_name | Display name for the Internet Gateway | `string` | `"internet-gateway"` | no |
| internet_gateway_enabled | Whether the Internet Gateway is enabled | `bool` | `true` | no |
| create_nat_gateway | Whether to create a NAT Gateway | `bool` | `false` | no |
| nat_gateway_display_name | Display name for the NAT Gateway | `string` | `"nat-gateway"` | no |
| nat_gateway_block_traffic | Whether to block traffic on the NAT Gateway | `bool` | `false` | no |
| create_service_gateway | Whether to create a Service Gateway | `bool` | `false` | no |
| service_gateway_display_name | Display name for the Service Gateway | `string` | `"service-gateway"` | no |
| service_gateway_services | List of services for the Service Gateway | `list(object` | `[]` | no |
| public_subnets | Map of public subnets to create | `map(object` | `{}` | no |
| private_subnets | Map of private subnets to create | `map(object` | `{}` | no |
| project | Project name for tagging | `string` | `"oci-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| freeform_tags | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| defined_tags | Defined tags to apply to all resources | `map(map(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vcn_id | OCID of the VCN |
| vcn_cidr_blocks | CIDR blocks of the VCN |
| vcn_display_name | Display name of the VCN |
| internet_gateway_id | OCID of the Internet Gateway |
| nat_gateway_id | OCID of the NAT Gateway |
| service_gateway_id | OCID of the Service Gateway |
| public_subnet_ids | Map of public subnet IDs |
| private_subnet_ids | Map of private subnet IDs |
| public_subnet_cidrs | Map of public subnet CIDR blocks |
| private_subnet_cidrs | Map of private subnet CIDR blocks |
| public_route_table_ids | Map of public route table IDs |
| private_route_table_ids | Map of private route table IDs |
| public_security_list_ids | Map of public security list IDs |
| private_security_list_ids | Map of private security list IDs |
| availability_domains | List of availability domain names |

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, usage patterns, and data transfer volumes.

### Always Free Tier

The following resources are **free** within Always Free tier limits:
- VCN, subnets, route tables, security lists
- Internet Gateway
- Service Gateway
- Up to 2 NAT Gateways (if within Always Free compute limits)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **VCN & Networking** | | |
| VCN, Subnets, Route Tables | 1 VCN, 2 public + 2 private subnets | **$0** (Free) |
| Internet Gateway | 1 gateway | **$0** (Free) |
| Service Gateway | 1 gateway | **$0** (Free) |
| NAT Gateway | 1 gateway (24/7) | ~**$32-35** (hourly + data processing) |
| NAT Gateway Data Processing | 100 GB/month | ~**$4.50** |
| **Network Security Groups** | 2 NSGs | **$0** (Free) |
| **Dynamic Routing Gateway** | 1 DRG | ~**$36-40** (if used) |
| **Local Peering Gateway** | 1 LPG | **$0** (Free) |
| **Flow Logs** | 1 flow log, 10 GB/month | ~**$2-3** (storage + ingestion) |
| **Total (Basic Setup)** | VCN + NAT Gateway + minimal data | **~$35-45/month** |
| **Total (With DRG)** | VCN + NAT Gateway + DRG | **~$70-80/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - NAT Gateway charges apply only when traffic flows through it
> - Data transfer costs vary by region and volume
> - DRG is only needed for cross-VCN or on-premises connectivity
> - Flow Logs storage costs depend on log volume
> - To minimize costs, disable NAT Gateway if not needed, or use a single NAT Gateway for multiple subnets

### Cost Optimization Tips

1. **Disable NAT Gateway** if private subnets don't need internet access
2. **Use Service Gateway** instead of NAT Gateway for OCI service access (free)
3. **Consolidate subnets** to reduce route table and security list overhead
4. **Monitor Flow Logs** volume to control storage costs
5. **Use DRG only when necessary** for multi-VCN or hybrid connectivity

## Examples

See the [examples](../examples/vcn/) directory for complete examples.

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
| [oci_core_drg.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg) | resource |
| [oci_core_drg_attachment.vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg_attachment) | resource |
| [oci_core_drg_route_distribution.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg_route_distribution) | resource |
| [oci_core_drg_route_table.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg_route_table) | resource |
| [oci_core_internet_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_local_peering_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_local_peering_gateway) | resource |
| [oci_core_nat_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_nat_gateway) | resource |
| [oci_core_network_security_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_route_table.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table_attachment.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_route_table_attachment.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_security_list.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_service_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_service_gateway) | resource |
| [oci_core_subnet.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_logging_log.vcn_flow_log](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/logging_log) | resource |
| [oci_logging_log_group.vcn_flow_logs](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/logging_log_group) | resource |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_drg_to_vcn"></a> [attach\_drg\_to\_vcn](#input\_attach\_drg\_to\_vcn) | Whether to attach DRG to VCN | `bool` | `false` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the VCN will be created | `string` | n/a | yes |
| <a name="input_create_drg"></a> [create\_drg](#input\_create\_drg) | Whether to create a Dynamic Routing Gateway | `bool` | `false` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Whether to create an Internet Gateway | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Whether to create a NAT Gateway | `bool` | `false` | no |
| <a name="input_create_service_gateway"></a> [create\_service\_gateway](#input\_create\_service\_gateway) | Whether to create a Service Gateway | `bool` | `false` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (core networking resources expect map(string)) | `map(string)` | `{}` | no |
| <a name="input_drg_display_name"></a> [drg\_display\_name](#input\_drg\_display\_name) | Display name for the DRG | `string` | `"drg"` | no |
| <a name="input_drg_route_distributions"></a> [drg\_route\_distributions](#input\_drg\_route\_distributions) | Map of DRG route distributions to create | <pre>map(object({<br/>    display_name      = string<br/>    distribution_type = string<br/>  }))</pre> | `{}` | no |
| <a name="input_drg_route_tables"></a> [drg\_route\_tables](#input\_drg\_route\_tables) | Map of DRG route tables to create | <pre>map(object({<br/>    display_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6 for the VCN | `bool` | `false` | no |
| <a name="input_enable_vcn_flow_logs"></a> [enable\_vcn\_flow\_logs](#input\_enable\_vcn\_flow\_logs) | Whether to enable VCN Flow Logs | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_internet_gateway_display_name"></a> [internet\_gateway\_display\_name](#input\_internet\_gateway\_display\_name) | Display name for the Internet Gateway | `string` | `"internet-gateway"` | no |
| <a name="input_internet_gateway_enabled"></a> [internet\_gateway\_enabled](#input\_internet\_gateway\_enabled) | Whether the Internet Gateway is enabled | `bool` | `true` | no |
| <a name="input_local_peering_gateways"></a> [local\_peering\_gateways](#input\_local\_peering\_gateways) | Map of Local Peering Gateways to create | <pre>map(object({<br/>    display_name   = string<br/>    route_table_id = optional(string, null)<br/>    peer_id        = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_nat_gateway_block_traffic"></a> [nat\_gateway\_block\_traffic](#input\_nat\_gateway\_block\_traffic) | Whether to block traffic on the NAT Gateway | `bool` | `false` | no |
| <a name="input_nat_gateway_display_name"></a> [nat\_gateway\_display\_name](#input\_nat\_gateway\_display\_name) | Display name for the NAT Gateway | `string` | `"nat-gateway"` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Map of Network Security Groups to create | <pre>map(object({<br/>    display_name  = string<br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_nsg_egress_rules"></a> [nsg\_egress\_rules](#input\_nsg\_egress\_rules) | Map of NSG egress rules to create | <pre>map(object({<br/>    nsg_key          = string<br/>    protocol         = string<br/>    description      = optional(string, "")<br/>    destination      = string<br/>    destination_type = string<br/>    is_stateless     = optional(bool, false)<br/>    tcp_options = optional(object({<br/>      destination_port_min = number<br/>      destination_port_max = number<br/>      source_port_min      = optional(number, null)<br/>      source_port_max      = optional(number, null)<br/>    }), null)<br/>    udp_options = optional(object({<br/>      destination_port_min = number<br/>      destination_port_max = number<br/>      source_port_min      = optional(number, null)<br/>      source_port_max      = optional(number, null)<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_nsg_ingress_rules"></a> [nsg\_ingress\_rules](#input\_nsg\_ingress\_rules) | Map of NSG ingress rules to create | <pre>map(object({<br/>    nsg_key      = string<br/>    protocol     = string<br/>    description  = optional(string, "")<br/>    source       = string<br/>    source_type  = string<br/>    is_stateless = optional(bool, false)<br/>    tcp_options = optional(object({<br/>      destination_port_min = number<br/>      destination_port_max = number<br/>      source_port_min      = optional(number, null)<br/>      source_port_max      = optional(number, null)<br/>    }), null)<br/>    udp_options = optional(object({<br/>      destination_port_min = number<br/>      destination_port_max = number<br/>      source_port_min      = optional(number, null)<br/>      source_port_max      = optional(number, null)<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_private_subnet_egress_rules"></a> [private\_subnet\_egress\_rules](#input\_private\_subnet\_egress\_rules) | Egress rules for default private subnet security lists. Set to null to use default (allow all outbound) | <pre>list(object({<br/>    protocol         = string<br/>    destination      = string<br/>    destination_type = optional(string, "CIDR_BLOCK")<br/>    description      = optional(string, "")<br/>    tcp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    udp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `null` | no |
| <a name="input_private_subnet_ingress_rules"></a> [private\_subnet\_ingress\_rules](#input\_private\_subnet\_ingress\_rules) | Ingress rules for default private subnet security lists. source=null uses first VCN CIDR. Default is empty (locked down). User must provide rules to allow traffic. | <pre>list(object({<br/>    protocol    = string<br/>    source      = optional(string, null)<br/>    source_type = optional(string, "CIDR_BLOCK")<br/>    description = optional(string, "")<br/>    tcp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    udp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Map of private subnets to create | <pre>map(object({<br/>    cidr_block          = string<br/>    display_name        = string<br/>    dns_label           = optional(string, "")<br/>    availability_domain = string<br/>    security_list_ids   = optional(list(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_public_subnet_egress_rules"></a> [public\_subnet\_egress\_rules](#input\_public\_subnet\_egress\_rules) | Egress rules for default public subnet security lists. Set to null to use default (allow all outbound) | <pre>list(object({<br/>    protocol         = string<br/>    destination      = string<br/>    destination_type = optional(string, "CIDR_BLOCK")<br/>    description      = optional(string, "")<br/>    tcp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    udp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `null` | no |
| <a name="input_public_subnet_ingress_rules"></a> [public\_subnet\_ingress\_rules](#input\_public\_subnet\_ingress\_rules) | Ingress rules for default public subnet security lists. Default is empty (locked down). User must provide rules to allow traffic. | <pre>list(object({<br/>    protocol    = string<br/>    source      = string<br/>    source_type = optional(string, "CIDR_BLOCK")<br/>    description = optional(string, "")<br/>    tcp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    udp_options = optional(object({<br/>      min = number<br/>      max = number<br/>    }), null)<br/>    icmp_options = optional(object({<br/>      type = number<br/>      code = optional(number, null)<br/>    }), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Map of public subnets to create | <pre>map(object({<br/>    cidr_block          = string<br/>    display_name        = string<br/>    dns_label           = optional(string, "")<br/>    availability_domain = string<br/>    security_list_ids   = optional(list(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_service_gateway_display_name"></a> [service\_gateway\_display\_name](#input\_service\_gateway\_display\_name) | Display name for the Service Gateway | `string` | `"service-gateway"` | no |
| <a name="input_service_gateway_services"></a> [service\_gateway\_services](#input\_service\_gateway\_services) | List of services for the Service Gateway | <pre>list(object({<br/>    service_id   = string<br/>    service_name = string<br/>    cidr_block   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of the tenancy | `string` | n/a | yes |
| <a name="input_vcn_cidr_blocks"></a> [vcn\_cidr\_blocks](#input\_vcn\_cidr\_blocks) | List of CIDR blocks for the VCN | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | Display name for the VCN | `string` | `"vcn"` | no |
| <a name="input_vcn_dns_label"></a> [vcn\_dns\_label](#input\_vcn\_dns\_label) | DNS label for the VCN | `string` | `null` | no |
| <a name="input_vcn_flow_log_enabled"></a> [vcn\_flow\_log\_enabled](#input\_vcn\_flow\_log\_enabled) | Whether the VCN flow log is enabled (when enable\_vcn\_flow\_logs is true) | `bool` | `true` | no |
| <a name="input_vcn_flow_log_retention_duration"></a> [vcn\_flow\_log\_retention\_duration](#input\_vcn\_flow\_log\_retention\_duration) | Retention duration in days for VCN Flow Logs | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_domains"></a> [availability\_domains](#output\_availability\_domains) | List of availability domain names |
| <a name="output_drg_attachment_id"></a> [drg\_attachment\_id](#output\_drg\_attachment\_id) | OCID of the DRG attachment to VCN |
| <a name="output_drg_id"></a> [drg\_id](#output\_drg\_id) | OCID of the Dynamic Routing Gateway |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | OCID of the Internet Gateway |
| <a name="output_local_peering_gateway_ids"></a> [local\_peering\_gateway\_ids](#output\_local\_peering\_gateway\_ids) | Map of Local Peering Gateway IDs |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | OCID of the NAT Gateway |
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | Map of Network Security Group IDs |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | Map of private route table IDs |
| <a name="output_private_security_list_ids"></a> [private\_security\_list\_ids](#output\_private\_security\_list\_ids) | Map of private security list IDs |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | Map of private subnet CIDR blocks |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Map of private subnet IDs |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | Map of public route table IDs |
| <a name="output_public_security_list_ids"></a> [public\_security\_list\_ids](#output\_public\_security\_list\_ids) | Map of public security list IDs |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | Map of public subnet CIDR blocks |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Map of public subnet IDs |
| <a name="output_service_gateway_id"></a> [service\_gateway\_id](#output\_service\_gateway\_id) | OCID of the Service Gateway |
| <a name="output_vcn_cidr_blocks"></a> [vcn\_cidr\_blocks](#output\_vcn\_cidr\_blocks) | CIDR blocks of the VCN |
| <a name="output_vcn_display_name"></a> [vcn\_display\_name](#output\_vcn\_display\_name) | Display name of the VCN |
| <a name="output_vcn_flow_log_id"></a> [vcn\_flow\_log\_id](#output\_vcn\_flow\_log\_id) | OCID of the Logging service log for VCN flow logs |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | OCID of the VCN |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for VCN module |
<!-- END_TF_DOCS -->
