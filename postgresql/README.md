# PostgreSQL

Creates an OCI PostgreSQL database system with OCI optimized storage. Provider 9.11.0 added in-place major version migration: `allow_major_version_upgrade` and `upgrade_options`.

The administrator password comes from a Vault secret by default. `PLAIN_TEXT` is accepted and stores the password in Terraform state.

OCI PostgreSQL is not an Always Free service. The basic example uses one flexible node at 2 OCPU and 10 GB, which is the small shape in the provider example and is billed.

Changing `db_version` replaces the database system unless `allow_major_version_upgrade` is true. `upgrade_options` runs only during that in-place upgrade. `RUN_POST_UPGRADE_VACUUM` is one operation the provider accepts.

## Usage

```hcl
module "postgresql" {
  source = "../postgresql"

  compartment_id              = var.compartment_id
  display_name                = "app-postgres"
  db_version                  = "14"
  shape                       = "PostgreSQL.VM.Standard.E4.Flex"
  instance_ocpu_count         = 2
  instance_memory_size_in_gbs = 10
  subnet_id                   = var.subnet_id
  admin_username              = "appadmin"
  admin_password_secret_id    = var.admin_password_secret_id
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
| [oci_psql_db_system.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/psql_db_system) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Administrator password. Required only when admin\_password\_type is PLAIN\_TEXT. The value is stored in Terraform state. | `string` | `null` | no |
| <a name="input_admin_password_secret_id"></a> [admin\_password\_secret\_id](#input\_admin\_password\_secret\_id) | Vault secret OCID that holds the administrator password. Required when admin\_password\_type is VAULT\_SECRET. | `string` | `null` | no |
| <a name="input_admin_password_secret_version"></a> [admin\_password\_secret\_version](#input\_admin\_password\_secret\_version) | Vault secret version for the administrator password. Leave null to use the current version. | `string` | `null` | no |
| <a name="input_admin_password_type"></a> [admin\_password\_type](#input\_admin\_password\_type) | How the administrator password is supplied. VAULT\_SECRET reads it from Vault. PLAIN\_TEXT stores it in Terraform state. | `string` | `"VAULT_SECRET"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Administrator username. Do not use a PostgreSQL reserved role name. | `string` | n/a | yes |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Allow an in-place upgrade when db\_version changes to a higher major version. Provider 9.11.0 added this argument. When false, changing db\_version replaces the database system. | `bool` | `false` | no |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain for storage. Leave null to let OCI choose. | `string` | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the PostgreSQL database system. | `string` | n/a | yes |
| <a name="input_config_id"></a> [config\_id](#input\_config\_id) | OCID of a PostgreSQL configuration to attach. Leave null to use the service default. | `string` | `null` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | PostgreSQL major version, for example 14 or 15. With allow\_major\_version\_upgrade, changing this value upgrades in place. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the database system. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the PostgreSQL database system. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the PostgreSQL database system. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of database instances. Use 1 for a single node. | `number` | `1` | no |
| <a name="input_instance_memory_size_in_gbs"></a> [instance\_memory\_size\_in\_gbs](#input\_instance\_memory\_size\_in\_gbs) | Memory in gigabytes for a flexible shape. Leave null for a fixed shape. | `number` | `null` | no |
| <a name="input_instance_ocpu_count"></a> [instance\_ocpu\_count](#input\_instance\_ocpu\_count) | OCPU count for a flexible shape. Leave null for a fixed shape. | `number` | `null` | no |
| <a name="input_is_reader_endpoint_enabled"></a> [is\_reader\_endpoint\_enabled](#input\_is\_reader\_endpoint\_enabled) | Create a reader endpoint in addition to the primary endpoint. | `bool` | `false` | no |
| <a name="input_is_regionally_durable"></a> [is\_regionally\_durable](#input\_is\_regionally\_durable) | Store database data with regional durability. | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | OCID of a Vault key used to encrypt the database. Leave null for Oracle-managed encryption. | `string` | `null` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | Network security groups attached to the database endpoint. Empty leaves the endpoint on the subnet security lists only. | `set(string)` | `[]` | no |
| <a name="input_primary_db_endpoint_private_ip"></a> [primary\_db\_endpoint\_private\_ip](#input\_primary\_db\_endpoint\_private\_ip) | Optional private IP for the primary endpoint. Leave null to let OCI allocate one. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | PostgreSQL shape. Flexible shapes require instance\_ocpu\_count and instance\_memory\_size\_in\_gbs. | `string` | n/a | yes |
| <a name="input_storage_iops"></a> [storage\_iops](#input\_storage\_iops) | Storage IOPS requested from the service. Leave null for the service default. | `string` | `null` | no |
| <a name="input_storage_system_type"></a> [storage\_system\_type](#input\_storage\_system\_type) | Storage system type for the database. | `string` | `"OCI_OPTIMIZED_STORAGE"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the private subnet for the database endpoint. | `string` | n/a | yes |
| <a name="input_system_type"></a> [system\_type](#input\_system\_type) | Database system type. | `string` | `"OCI_OPTIMIZED_STORAGE"` | no |
| <a name="input_upgrade_options"></a> [upgrade\_options](#input\_upgrade\_options) | Post-upgrade operations applied only when db\_version changes and allow\_major\_version\_upgrade is true. RUN\_POST\_UPGRADE\_VACUUM is one operation the provider accepts. An empty list skips verification and vacuum. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | Administrator username reported by the database system. |
| <a name="output_db_system_id"></a> [db\_system\_id](#output\_db\_system\_id) | OCID of the PostgreSQL database system. |
| <a name="output_state"></a> [state](#output\_state) | Lifecycle state of the PostgreSQL database system. |
<!-- END_TF_DOCS -->
