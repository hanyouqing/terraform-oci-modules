# Generative AI dedicated cluster

Creates a Generative AI dedicated AI cluster for hosting or fine-tuning. Provider 9.11.0 added `capacity_reservation_id`, so a cluster can bring a reserved capacity unit instead of using on-demand capacity.

Leave `capacity_reservation_id` null unless the reservation already exists. Unit shape and count are required because dedicated clusters are billed GPU capacity. There is no Always Free shape.

Requirements, the surrounding landing zone, and what this module does not create are in [docs/oci-solutions-architect/08-ai.md](../docs/oci-solutions-architect/08-ai.md).

## Usage

```hcl
module "generative_ai" {
  source = "../generative-ai"

  compartment_id = var.compartment_id
  cluster_type   = "HOSTING"
  unit_count     = 1
  unit_shape = var.unit_shape
  display_name   = "hosting"
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
| [oci_generative_ai_dedicated_ai_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/generative_ai_dedicated_ai_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_capacity_reservation_id"></a> [capacity\_reservation\_id](#input\_capacity\_reservation\_id) | OCID of a Generative AI capacity reservation to bring to this dedicated AI cluster. Provider 9.11.0 added this argument. Leave null to consume on-demand capacity. | `string` | `null` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Dedicated AI cluster type. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the dedicated AI cluster. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the cluster. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the dedicated AI cluster. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the dedicated AI cluster. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_unit_count"></a> [unit\_count](#input\_unit\_count) | Number of capacity units in the cluster. | `number` | n/a | yes |
| <a name="input_unit_shape"></a> [unit\_shape](#input\_unit\_shape) | Unit shape available for this cluster type in the target region. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_capacity_reservation_id"></a> [capacity\_reservation\_id](#output\_capacity\_reservation\_id) | Capacity reservation attached to the dedicated AI cluster, when one was set. |
| <a name="output_dedicated_ai_cluster_id"></a> [dedicated\_ai\_cluster\_id](#output\_dedicated\_ai\_cluster\_id) | OCID of the dedicated AI cluster. |
| <a name="output_state"></a> [state](#output\_state) | Lifecycle state of the dedicated AI cluster. |
<!-- END_TF_DOCS -->
