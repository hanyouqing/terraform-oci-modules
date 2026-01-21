# VCN Module

This module creates a Virtual Cloud Network (VCN) in Oracle Cloud Infrastructure with public and private subnets, Internet Gateway, NAT Gateway, Service Gateway, route tables, and security lists.

## Features

- Create VCN with customizable CIDR blocks
- Create public and private subnets
- Internet Gateway for public subnets
- NAT Gateway for private subnets (optional)
- Service Gateway for OCI services (optional)
- Route tables for public and private subnets
- Security lists with default rules
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
