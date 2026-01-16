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

## Examples

See the [examples](../examples/bastion/) directory for complete examples.
