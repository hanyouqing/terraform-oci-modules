# Full Stack Disaster Recovery

Creates an OCI Full Stack Disaster Recovery protection group with a required Object Storage log location. Optional peer association and members. Plans and executions are not managed here. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "fsdr" {
  source = "../fsdr"

  compartment_id = var.compartment_id
  display_name   = "app-dr-primary"
  log_bucket     = var.log_bucket
  log_namespace  = var.log_namespace
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.11 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 9.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_disaster_recovery_dr_protection_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/disaster_recovery_dr_protection_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_association"></a> [association](#input\_association) | Optional peer association. role is PRIMARY or STANDBY. Null creates an unassociated group. | <pre>object({<br/>    role        = string<br/>    peer_id     = optional(string)<br/>    peer_region = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID for the DR protection group. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the protection group. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the DR protection group. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | Object Storage bucket name for Full Stack Disaster Recovery logs. | `string` | n/a | yes |
| <a name="input_log_namespace"></a> [log\_namespace](#input\_log\_namespace) | Object Storage namespace for Full Stack Disaster Recovery logs. | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | Optional members (COMPUTE\_INSTANCE, VOLUME\_GROUP, AUTONOMOUS\_DATABASE, and other Full Stack DR member types). Empty creates the group only. | <pre>list(object({<br/>    member_id   = string<br/>    member_type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_dr_protection_group_id"></a> [dr\_protection\_group\_id](#output\_dr\_protection\_group\_id) | OCID of the DR protection group. |
| <a name="output_role"></a> [role](#output\_role) | Role of the protection group when associated. |
<!-- END_TF_DOCS -->
