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
| [oci_bastion_bastion.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_bastion) | resource |
| [oci_bastion_session.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_session) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_type"></a> [bastion\_type](#input\_bastion\_type) | Type of bastion: STANDARD or SESSION | `string` | `"STANDARD"` | no |
| <a name="input_client_cidr_block_allow_list"></a> [client\_cidr\_block\_allow\_list](#input\_client\_cidr\_block\_allow\_list) | List of CIDR blocks allowed to connect to the bastion. Recommended to restrict to your own public IP (e.g., ['1.2.3.4/32']). | `list(string)` | `[]` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the bastion will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (OCI provider expects map(string) for this resource) | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_max_session_ttl_in_seconds"></a> [max\_session\_ttl\_in\_seconds](#input\_max\_session\_ttl\_in\_seconds) | Maximum session TTL in seconds | `number` | `10800` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the bastion | `string` | `"bastion"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_sessions"></a> [sessions](#input\_sessions) | Map of bastion sessions to create | <pre>map(object({<br/>    display_name                               = string<br/>    public_key_content                         = string<br/>    session_type                               = string<br/>    target_resource_id                         = optional(string, null)<br/>    target_resource_operating_system_user_name = optional(string, null)<br/>    target_resource_port                       = optional(number, 22)<br/>    target_resource_private_ip_address         = optional(string, null)<br/>    session_ttl_in_seconds                     = optional(number, 3600)<br/>  }))</pre> | `{}` | no |
| <a name="input_target_subnet_id"></a> [target\_subnet\_id](#input\_target\_subnet\_id) | OCID of the target subnet for the bastion | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | OCID of the bastion |
| <a name="output_bastion_name"></a> [bastion\_name](#output\_bastion\_name) | Name of the bastion |
| <a name="output_session_ids"></a> [session\_ids](#output\_session\_ids) | OCIDs of the bastion sessions |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Bastion module |
<!-- END_TF_DOCS -->
