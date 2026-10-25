# Functions

Creates a Functions application and optional functions from OCIR images in the same region. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "functions" {
  source = "../functions"

  compartment_id = var.compartment_id
  display_name   = "app-fn"
  subnet_ids     = [var.private_subnet_id]
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
| [oci_functions_application.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/functions_application) | resource |
| [oci_functions_function.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/functions_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_application_config"></a> [application\_config](#input\_application\_config) | Application-level configuration passed to functions as environment variables. | `map(string)` | `{}` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID for the Functions application. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the application and functions. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Functions application. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_functions"></a> [functions](#input\_functions) | Functions keyed by display name. image is an OCIR image reference in the same region. Empty creates only the application. | <pre>map(object({<br/>    image              = string<br/>    memory_in_mbs      = number<br/>    timeout_in_seconds = optional(number, 30)<br/>    image_digest       = optional(string)<br/>    config             = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | NSG OCIDs for the application. | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | GENERIC\_X86 or GENERIC\_ARM for function execution. | `string` | `"GENERIC_X86"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet OCIDs for the application. Prefer private subnets. | `list(string)` | n/a | yes |
| <a name="input_syslog_url"></a> [syslog\_url](#input\_syslog\_url) | Optional syslog URL for function logs. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | OCID of the Functions application. |
| <a name="output_function_ids"></a> [function\_ids](#output\_function\_ids) | Function OCIDs keyed by display name. |
| <a name="output_invoke_endpoints"></a> [invoke\_endpoints](#output\_invoke\_endpoints) | HTTPS invoke endpoints keyed by function display name. |
<!-- END_TF_DOCS -->
