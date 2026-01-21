# Bastion Module

This module creates and manages Bastion service resources in Oracle Cloud Infrastructure.

## Features

- Create bastion hosts
- Create bastion sessions
- SSH session management
- Comprehensive tagging support

## Always Free Limits

- Bastion service is free for both free and paid accounts

## Usage

```hcl
module "bastion" {
  source = "../bastion"

  compartment_id    = var.compartment_id
  target_subnet_id  = module.vcn.private_subnet_ids["private-subnet-1"]
  bastion_type      = "STANDARD"
  name              = "my-bastion"

  client_cidr_block_allow_list = ["0.0.0.0/0"]

  sessions = {
    session-1 = {
      display_name                              = "session-1"
      public_key_content                        = file("~/.ssh/id_rsa.pub")
      session_type                              = "SSH"
      target_resource_id                        = module.compute.instance_ids[0]
      target_resource_operating_system_user_name = "opc"
      target_resource_port                      = 22
      target_resource_private_ip_address        = module.compute.instance_private_ips[0]
      session_ttl_in_seconds                     = 3600
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

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region and session usage.

### Always Free Tier

The following Bastion resources are **free** for both free and paid accounts:
- **Bastion Hosts**: Unlimited
- **Bastion Sessions**: Unlimited
- **Session Duration**: Up to 3 hours per session
- **Concurrent Sessions**: Limited by bastion type

### Cost Breakdown

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Bastion Service** | | |
| Standard Bastion | 1 bastion host | **$0** (Free) |
| Standard Bastion Sessions | Unlimited sessions | **$0** (Free) |
| **Total** | Any configuration | **$0** (Free) |

> **Notes:**
> - Bastion service is completely free for all account types
> - No charges for bastion hosts, sessions, or data transfer
> - Session duration is limited to 3 hours per session
> - Standard bastion supports up to 50 concurrent sessions
> - No cost optimization needed - service is free

### Cost Optimization Tips

1. **No cost optimization needed** - Bastion service is free
2. **Use Standard bastion** for most use cases (free)
3. **Reuse sessions** when possible to avoid session creation overhead
4. **Monitor session usage** to ensure compliance with concurrent session limits

## Examples

See the [examples](../examples/bastion/) directory for complete examples.
