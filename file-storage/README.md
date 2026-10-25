# File Storage

Creates one file system, one mount target, and one export. The export allows a single client CIDR, squashes root, and rejects `0.0.0.0/0`.

File Storage is not an Always Free service. Put the mount target in a private subnet and allow NFS only from the export CIDR. Root is squashed, and clients must connect from a privileged source port. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "file_storage" {
  source = "../file-storage"

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "app"
  subnet_id           = var.subnet_id
  export_source_cidr  = "10.10.0.0/16"
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
| [oci_file_storage_export.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/file_storage_export) | resource |
| [oci_file_storage_file_system.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/file_storage_file_system) | resource |
| [oci_file_storage_mount_target.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/file_storage_mount_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain for the file system and mount target. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the file system and mount target. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the file system and mount target. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the file system. The mount target appends -mt. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_export_path"></a> [export\_path](#input\_export\_path) | Export path clients use in the mount command. | `string` | `"/export"` | no |
| <a name="input_export_source_cidr"></a> [export\_source\_cidr](#input\_export\_source\_cidr) | Client CIDR allowed to mount the export. Use the VCN or application CIDR. | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_hostname_label"></a> [hostname\_label](#input\_hostname\_label) | DNS label for the mount target. Null omits it. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Vault key OCID for the file system. Null uses Oracle-managed encryption. | `string` | `null` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | NSG OCIDs for the mount target. Allow NFS only from export\_source\_cidr. | `set(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the subnet for the mount target. Use a private subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_export_id"></a> [export\_id](#output\_export\_id) | OCID of the export. |
| <a name="output_export_set_id"></a> [export\_set\_id](#output\_export\_set\_id) | OCID of the export set created with the mount target. |
| <a name="output_file_system_id"></a> [file\_system\_id](#output\_file\_system\_id) | OCID of the file system. |
| <a name="output_mount_target_id"></a> [mount\_target\_id](#output\_mount\_target\_id) | OCID of the mount target. |
<!-- END_TF_DOCS -->
