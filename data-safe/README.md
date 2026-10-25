# Data Safe

Enables Data Safe for the tenancy. A private endpoint and Autonomous Database targets are optional.

The target API requires the database password on the resource, so a registered target stores that password in state. Leave `target_databases` empty until that tradeoff is accepted. Prefer registering the target from a workflow that reads the password from Vault at apply time and does not commit it. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "data_safe" {
  source = "../data-safe"

  tenancy_ocid = var.tenancy_ocid
  is_enabled   = true
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
| <a name="provider_oci"></a> [oci](#provider\_oci) | 9.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_data_safe_data_safe_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/data_safe_data_safe_configuration) | resource |
| [oci_data_safe_data_safe_private_endpoint.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/data_safe_data_safe_private_endpoint) | resource |
| [oci_data_safe_target_database.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/data_safe_target_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment for the private endpoint and target databases. Required when private\_endpoint or target\_databases is set. | `string` | `null` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the private endpoint and targets. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Enable Data Safe for the tenancy. | `bool` | `true` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Private endpoint used to reach databases that have no public IP. Null skips it. | <pre>object({<br/>    display_name = string<br/>    subnet_id    = string<br/>    vcn_id       = string<br/>    nsg_ids      = optional(set(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_target_database_passwords"></a> [target\_database\_passwords](#input\_target\_database\_passwords) | Passwords for target\_databases, keyed by the same name. Sensitive. The Data Safe API requires the password on the target resource, so it is stored in state. | `map(string)` | `{}` | no |
| <a name="input_target_databases"></a> [target\_databases](#input\_target\_databases) | Autonomous Databases to register. Each key must exist in target\_database\_passwords. The provider stores the password in state. | <pre>map(object({<br/>    user_name              = string<br/>    autonomous_database_id = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenancy OCID. Data Safe configuration is a tenancy resource. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether Data Safe is enabled for the tenancy. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | OCID of the Data Safe private endpoint. Null when private\_endpoint is not set. |
| <a name="output_target_database_ids"></a> [target\_database\_ids](#output\_target\_database\_ids) | OCIDs of registered target databases, keyed by display name. |
<!-- END_TF_DOCS -->
