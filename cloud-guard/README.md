# Cloud Guard

Enables the tenancy Cloud Guard configuration and optional compartment targets. Detector and responder recipe OCIDs come from the caller. The module does not clone Oracle managed recipes.

Cloud Guard configuration and targets are unmetered on the price list. Cloud Guard is not available on a Free Tier tenancy. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "cloud_guard" {
  source = "../cloud-guard"

  tenancy_ocid     = var.tenancy_ocid
  reporting_region = "ap-seoul-1"
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
| [oci_cloud_guard_cloud_guard_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_cloud_guard_configuration) | resource |
| [oci_cloud_guard_target.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to targets. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_reporting_region"></a> [reporting\_region](#input\_reporting\_region) | Home region that stores Cloud Guard findings. Changing it later recreates the reporting setup. | `string` | n/a | yes |
| <a name="input_status"></a> [status](#input\_status) | ENABLED turns Cloud Guard on for the tenancy. | `string` | `"ENABLED"` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Targets to monitor. detector\_recipe\_ids are existing Oracle-managed or cloned recipe OCIDs. The module does not clone recipes. | <pre>map(object({<br/>    compartment_id       = string<br/>    target_resource_id   = string<br/>    target_resource_type = optional(string, "COMPARTMENT")<br/>    detector_recipe_ids  = list(string)<br/>    responder_recipe_ids = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenancy OCID. Cloud Guard configuration is a tenancy resource. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_reporting_region"></a> [reporting\_region](#output\_reporting\_region) | Region where Cloud Guard reports findings. |
| <a name="output_status"></a> [status](#output\_status) | Cloud Guard status for the tenancy. |
| <a name="output_target_ids"></a> [target\_ids](#output\_target\_ids) | OCIDs of Cloud Guard targets, keyed by display name. |
<!-- END_TF_DOCS -->
