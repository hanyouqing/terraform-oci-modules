# Security Zones

Creates a Cloud Guard Security Zone for a compartment. Optionally creates a security recipe from caller-supplied policy OCIDs. Cloud Guard must already be enabled on the tenancy. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "security_zones" {
  source = "../security-zones"

  compartment_id    = var.compartment_id
  display_name      = "prod-zone"
  security_policies = var.security_policy_ocids
}
```

## Resource Manager

`examples/resource-manager` is a stack for OCI Resource Manager on Terraform 1.5.x. Zip that directory (do not include `.terraform`) and upload it as a stack. Choose Terraform 1.5.x. Resource Manager fills the tenancy and region. Set the compartment and the remaining required fields, then plan and apply.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 1.6.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.11 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.11 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_cloud_guard_security_recipe.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_security_recipe) | resource |
| [oci_cloud_guard_security_zone.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_security_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID that the Security Zone covers. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the zone and recipe. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Optional description of the Security Zone. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Security Zone. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_recipe_description"></a> [recipe\_description](#input\_recipe\_description) | Description for a module-created recipe. | `string` | `"Managed by terraform-oci-modules/security-zones"` | no |
| <a name="input_recipe_display_name"></a> [recipe\_display\_name](#input\_recipe\_display\_name) | Display name for a module-created recipe. Null derives from display\_name. | `string` | `null` | no |
| <a name="input_security_policies"></a> [security\_policies](#input\_security\_policies) | Security policy OCIDs for a new recipe. Required when security\_zone\_recipe\_id is null. List Oracle-managed policies in the target region. | `list(string)` | `[]` | no |
| <a name="input_security_zone_recipe_id"></a> [security\_zone\_recipe\_id](#input\_security\_zone\_recipe\_id) | Existing Security Zone recipe OCID. Null creates a recipe from security\_policies. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_security_zone_id"></a> [security\_zone\_id](#output\_security\_zone\_id) | OCID of the Security Zone. |
| <a name="output_security_zone_recipe_id"></a> [security\_zone\_recipe\_id](#output\_security\_zone\_recipe\_id) | OCID of the recipe attached to the zone. |
| <a name="output_security_zone_target_id"></a> [security\_zone\_target\_id](#output\_security\_zone\_target\_id) | OCID of the Cloud Guard target created with the zone. |
<!-- END_TF_DOCS -->
