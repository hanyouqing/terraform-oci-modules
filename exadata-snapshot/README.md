# Exadata database snapshot

Creates snapshots of an existing Exadata database. Provider 9.11.0 added `oci_database_database_snapshot` for the ExaDB-XS container database snapshot.

The module does not create the VM cluster or the database. The same release also added thin-clone arguments on `oci_database_database` (`source_snapshot_id`, `is_thin_clone`, and the source admin and TDE passwords). Those arguments belong on database creation, which still depends on a DB home or VM cluster this module does not manage.

Exadata snapshots are not Always Free.

## Usage

```hcl
module "database_snapshot" {
  source = "../exadata-snapshot"

  database_id = var.database_id

  snapshots = {
    nightly = {
      name = "nightly"
    }
  }
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
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.11 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_database_database_snapshot.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_database_snapshot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_database_id"></a> [database\_id](#input\_database\_id) | OCID of the Exadata database to snapshot. Provider 9.11.0 added this resource for ExaDB-XS container database snapshots. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags merged onto every snapshot. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto every snapshot. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_snapshots"></a> [snapshots](#input\_snapshots) | Snapshots to create for the database. The map key is only used inside Terraform. Each name must be unique on the database. | <pre>map(object({<br/>    name          = string<br/>    freeform_tags = optional(map(string), {})<br/>    defined_tags  = optional(map(string), {})<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_snapshot_ids"></a> [snapshot\_ids](#output\_snapshot\_ids) | OCIDs of the Exadata database snapshots, keyed by the snapshots map. |
| <a name="output_snapshot_states"></a> [snapshot\_states](#output\_snapshot\_states) | Lifecycle state of each Exadata database snapshot. |
<!-- END_TF_DOCS -->
