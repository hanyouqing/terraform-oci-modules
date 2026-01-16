# VCN Complete Example

This example demonstrates a production-ready VCN setup with all features enabled.

## Features

- VCN with multiple CIDR blocks
- Public and private subnets across multiple availability domains
- Internet Gateway, NAT Gateway, and Service Gateway
- Dynamic Routing Gateway (DRG) support
- Network Security Groups (NSG) with custom rules
- Local Peering Gateways (LPG)
- VCN Flow Logs for monitoring
- Comprehensive tagging
- IPv6 support (optional)

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Production Considerations

- Multi-AZ deployment with subnets in different availability domains
- Network segmentation with public and private subnets
- Security hardening with NSGs
- Monitoring with Flow Logs
- High availability with DRG for multi-region connectivity
- Comprehensive tagging for cost tracking and governance
