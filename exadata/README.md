# Exadata

Creates Cloud Exadata infrastructure. An optional VM cluster can be added on that infrastructure. Database homes and databases stay outside this module. Snapshots of an existing ExaDB-XS database stay in `exadata-snapshot`.

There is no Always Free shape and no default shape. `compute_count` starts at 2 and `storage_count` starts at 3. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "exadata" {
  source = "../exadata"

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "exa"
  shape               = "Exadata.X9M"
  compute_count       = 2
  storage_count       = 3
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
| [oci_database_cloud_exadata_infrastructure.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_cloud_exadata_infrastructure) | resource |
| [oci_database_cloud_vm_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_cloud_vm_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain for the Cloud Exadata infrastructure, for example ABcd:AP-SEOUL-1-AD-1. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the Exadata infrastructure. | `string` | n/a | yes |
| <a name="input_compute_count"></a> [compute\_count](#input\_compute\_count) | Number of compute servers. Use the minimum the chosen shape allows. | `number` | n/a | yes |
| <a name="input_customer_contact_emails"></a> [customer\_contact\_emails](#input\_customer\_contact\_emails) | Email addresses Oracle uses for infrastructure maintenance notices. | `list(string)` | `[]` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the infrastructure and VM cluster. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Cloud Exadata infrastructure. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | Exadata shape available in the region, for example Exadata.X9M. There is no default. This service is billed and has no Always Free shape. | `string` | n/a | yes |
| <a name="input_storage_count"></a> [storage\_count](#input\_storage\_count) | Number of storage servers. Use the minimum the chosen shape allows. | `number` | n/a | yes |
| <a name="input_vm_cluster"></a> [vm\_cluster](#input\_vm\_cluster) | Optional VM cluster on this infrastructure. Null creates the infrastructure only. Database homes and databases are separate resources. | <pre>object({<br/>    display_name           = string<br/>    hostname               = string<br/>    cpu_core_count         = number<br/>    gi_version             = string<br/>    subnet_id              = string<br/>    backup_subnet_id       = string<br/>    ssh_public_keys        = list(string)<br/>    license_model          = optional(string, "LICENSE_INCLUDED")<br/>    nsg_ids                = optional(set(string), [])<br/>    backup_network_nsg_ids = optional(set(string), [])<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_infrastructure_id"></a> [infrastructure\_id](#output\_infrastructure\_id) | OCID of the Cloud Exadata infrastructure. |
| <a name="output_vm_cluster_id"></a> [vm\_cluster\_id](#output\_vm\_cluster\_id) | OCID of the VM cluster. Null when vm\_cluster is not set. |
<!-- END_TF_DOCS -->
