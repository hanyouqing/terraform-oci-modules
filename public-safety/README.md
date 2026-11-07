# Public Safety

Creates an Oracle Public Safety and Security (PSS / AI-World) instance. OCI provider 9.11.0, published 2026-10-21, added `oci_pss_instance`.

The instance is bound to an existing identity domain. The module does not create the domain or the administrator user.

Public Safety is not an Always Free service. The basic example is the smallest valid instance and is billed. It is not a Generative AI cluster. See [docs/oci-solutions-architect/08-ai.md](../docs/oci-solutions-architect/08-ai.md).

## Usage

```hcl
module "public_safety" {
  source = "../public-safety"

  compartment_id                = var.compartment_id
  identity_domain_url           = "https://idcs-example.identity.oraclecloud.com"
  admin_identity_domain_user_id = var.admin_user_id
  display_name                  = "city-safety"
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
| [oci_pss_instance.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/pss_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_identity_domain_user_id"></a> [admin\_identity\_domain\_user\_id](#input\_admin\_identity\_domain\_user\_id) | OCID of the identity-domain user that initially administers the Public Safety instance. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the resource. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to resources that accept them. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Public Safety instance. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_identity_domain_url"></a> [identity\_domain\_url](#input\_identity\_domain\_url) | URL of the identity domain associated with the Public Safety instance. Example: https://idcs-1234567890.identity.oraclecloud.com. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | OCID of the Public Safety instance. |
| <a name="output_service_endpoint"></a> [service\_endpoint](#output\_service\_endpoint) | API endpoint of the Public Safety instance. |
| <a name="output_state"></a> [state](#output\_state) | Lifecycle state of the Public Safety instance. |
| <a name="output_ui_endpoint"></a> [ui\_endpoint](#output\_ui\_endpoint) | Console endpoint of the Public Safety instance. |
<!-- END_TF_DOCS -->
