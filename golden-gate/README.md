# GoldenGate connection

Creates one OCI GoldenGate connection. Provider 9.11.0 added Release 12 connection fields: cluster endpoint, workspace URL, REST endpoint, provider id, submit mode, RPC cipher, TLS protocol, key store type, trust store type, and the Vault secret forms of the auth material.

The module accepts credentials only as Vault secret OCIDs. Set `deployment` to add one private GoldenGate deployment. Leave it null to create the connection only. The deployment admin password is `password_secret_id`, a Vault secret OCID.

GoldenGate connections and deployments are not Always Free resources. A deployment is billed separately from the connection.

## Usage

```hcl
module "golden_gate" {
  source = "../golden-gate"

  compartment_id     = var.compartment_id
  display_name       = "postgres-source"
  connection_type    = "POSTGRESQL"
  technology_type    = "POSTGRESQL_SERVER"
  username           = "ggadmin"
  host               = "10.50.2.10"
  port               = 5432
  database_name      = "app"
  subnet_id          = var.subnet_id
  password_secret_id = var.password_secret_id
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
| [oci_golden_gate_connection.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/golden_gate_connection) | resource |
| [oci_golden_gate_deployment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/golden_gate_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_secret_secret_id"></a> [auth\_secret\_secret\_id](#input\_auth\_secret\_secret\_id) | Vault secret OCID for the Release 12 auth secret. | `string` | `null` | no |
| <a name="input_auth_token_secret_id"></a> [auth\_token\_secret\_id](#input\_auth\_token\_secret\_id) | Vault secret OCID for the Release 12 auth token. | `string` | `null` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | Cluster endpoint used by Release 12 connections such as a remote data platform. | `string` | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the GoldenGate connection. | `string` | n/a | yes |
| <a name="input_connection_string"></a> [connection\_string](#input\_connection\_string) | Connection string used by connection types that do not take host and port separately. | `string` | `null` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | GoldenGate connection type, for example GOLDENGATE or POSTGRESQL. | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Database name on the source or target. | `string` | `null` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the connection and, when set, the deployment. | `map(string)` | `{}` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | Optional GoldenGate deployment. Null keeps this module at the connection only. The admin password is a Vault secret OCID. | <pre>object({<br/>    display_name       = string<br/>    subnet_id          = string<br/>    deployment_type    = string<br/>    license_model      = string<br/>    cpu_core_count     = number<br/>    ogg_version        = string<br/>    admin_username     = string<br/>    password_secret_id = string<br/>    is_public          = optional(bool, false)<br/>    nsg_ids            = optional(set(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the connection. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the connection. | `string` | n/a | yes |
| <a name="input_does_use_secret_ids"></a> [does\_use\_secret\_ids](#input\_does\_use\_secret\_ids) | Tell GoldenGate that credentials are Vault secret OCIDs. Keep this true. The module does not accept plaintext secrets. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_host"></a> [host](#input\_host) | Hostname of the source or target. Leave null when the connection type uses an endpoint URL instead. | `string` | `null` | no |
| <a name="input_key_store_secret_id"></a> [key\_store\_secret\_id](#input\_key\_store\_secret\_id) | Vault secret OCID for the Release 12 key store. | `string` | `null` | no |
| <a name="input_key_store_type"></a> [key\_store\_type](#input\_key\_store\_type) | Key store type used by Release 12 connections. | `string` | `null` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | Network security groups for the private connection. | `set(string)` | `[]` | no |
| <a name="input_password_secret_id"></a> [password\_secret\_id](#input\_password\_secret\_id) | Vault secret OCID for the connection password. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Port of the source or target. | `number` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_provider_id"></a> [provider\_id](#input\_provider\_id) | Provider identifier used by Release 12 connections. | `string` | `null` | no |
| <a name="input_rest_auth_secret_key_secret_id"></a> [rest\_auth\_secret\_key\_secret\_id](#input\_rest\_auth\_secret\_key\_secret\_id) | Vault secret OCID for the Release 12 REST auth secret key. | `string` | `null` | no |
| <a name="input_rest_endpoint"></a> [rest\_endpoint](#input\_rest\_endpoint) | REST endpoint used by Release 12 connections. | `string` | `null` | no |
| <a name="input_rpc_cipher"></a> [rpc\_cipher](#input\_rpc\_cipher) | RPC cipher used by Release 12 connections. | `string` | `null` | no |
| <a name="input_submit_mode"></a> [submit\_mode](#input\_submit\_mode) | Submit mode used by Release 12 connections. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the subnet used for a private connection. Leave null for a connection that does not use a private endpoint. | `string` | `null` | no |
| <a name="input_technology_type"></a> [technology\_type](#input\_technology\_type) | Technology type paired with connection\_type. Release 12 types use the fields added in provider 9.11.0. | `string` | n/a | yes |
| <a name="input_tls_protocol"></a> [tls\_protocol](#input\_tls\_protocol) | TLS protocol used by Release 12 connections. | `string` | `null` | no |
| <a name="input_trust_store_secret_id"></a> [trust\_store\_secret\_id](#input\_trust\_store\_secret\_id) | Vault secret OCID for the Release 12 trust store. | `string` | `null` | no |
| <a name="input_trust_store_type"></a> [trust\_store\_type](#input\_trust\_store\_type) | Trust store type used by Release 12 connections. | `string` | `null` | no |
| <a name="input_username"></a> [username](#input\_username) | Database or service username. Leave null when the connection type does not use one. | `string` | `null` | no |
| <a name="input_vault_id"></a> [vault\_id](#input\_vault\_id) | Vault OCID that holds the connection secrets. | `string` | `null` | no |
| <a name="input_workspace_url"></a> [workspace\_url](#input\_workspace\_url) | Workspace URL used by Release 12 connections. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | OCID of the GoldenGate connection. |
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | OCID of the GoldenGate deployment. Null when deployment is not set. |
<!-- END_TF_DOCS -->
