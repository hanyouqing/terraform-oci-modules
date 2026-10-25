# OpenSearch

Creates an OCI OpenSearch cluster with security mode `ENFORCING`. The master user is set with an OpenSearch password hash. Do not pass the plaintext password.

Provider 9.11.0 added remote reindex trust. `remote_reindex_sources` is empty by default, so the cluster does not trust a remote endpoint until you add one. Each source needs an https endpoint and a CA bundle.

OpenSearch is not an Always Free service. Node counts and sizes are required inputs so a plan shows the billable shape before apply.

## Usage

```hcl
module "opensearch" {
  source = "../opensearch"

  compartment_id                     = var.compartment_id
  display_name                       = "search"
  software_version                   = "2.15.0"
  vcn_id                             = var.vcn_id
  subnet_id                          = var.subnet_id
  master_node_count                  = 1
  master_node_host_ocpu_count        = 1
  master_node_host_memory_gb         = 20
  data_node_count                    = 1
  data_node_host_ocpu_count          = 2
  data_node_host_memory_gb           = 20
  data_node_storage_gb               = 50
  opendashboard_node_count           = 1
  opendashboard_node_host_ocpu_count = 2
  opendashboard_node_host_memory_gb  = 10
  security_master_user_name          = "osadmin"
  security_master_user_password_hash = var.master_user_password_hash
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
| [oci_opensearch_opensearch_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/opensearch_opensearch_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the OpenSearch cluster. | `string` | n/a | yes |
| <a name="input_data_node_count"></a> [data\_node\_count](#input\_data\_node\_count) | Number of data nodes. | `number` | n/a | yes |
| <a name="input_data_node_host_memory_gb"></a> [data\_node\_host\_memory\_gb](#input\_data\_node\_host\_memory\_gb) | Memory in gigabytes of each data node. | `number` | n/a | yes |
| <a name="input_data_node_host_ocpu_count"></a> [data\_node\_host\_ocpu\_count](#input\_data\_node\_host\_ocpu\_count) | OCPU count of each data node. | `number` | n/a | yes |
| <a name="input_data_node_host_type"></a> [data\_node\_host\_type](#input\_data\_node\_host\_type) | Host type of the data nodes. | `string` | `"FLEX"` | no |
| <a name="input_data_node_storage_gb"></a> [data\_node\_storage\_gb](#input\_data\_node\_storage\_gb) | Data storage in gigabytes on each data node. | `number` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the cluster. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the OpenSearch cluster. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_master_node_count"></a> [master\_node\_count](#input\_master\_node\_count) | Number of cluster manager nodes. | `number` | n/a | yes |
| <a name="input_master_node_host_memory_gb"></a> [master\_node\_host\_memory\_gb](#input\_master\_node\_host\_memory\_gb) | Memory in gigabytes of each cluster manager node. | `number` | n/a | yes |
| <a name="input_master_node_host_ocpu_count"></a> [master\_node\_host\_ocpu\_count](#input\_master\_node\_host\_ocpu\_count) | OCPU count of each cluster manager node. | `number` | n/a | yes |
| <a name="input_master_node_host_type"></a> [master\_node\_host\_type](#input\_master\_node\_host\_type) | Host type of the cluster manager nodes. | `string` | `"FLEX"` | no |
| <a name="input_opendashboard_node_count"></a> [opendashboard\_node\_count](#input\_opendashboard\_node\_count) | Number of OpenSearch Dashboards nodes. | `number` | n/a | yes |
| <a name="input_opendashboard_node_host_memory_gb"></a> [opendashboard\_node\_host\_memory\_gb](#input\_opendashboard\_node\_host\_memory\_gb) | Memory in gigabytes of each OpenSearch Dashboards node. | `number` | n/a | yes |
| <a name="input_opendashboard_node_host_ocpu_count"></a> [opendashboard\_node\_host\_ocpu\_count](#input\_opendashboard\_node\_host\_ocpu\_count) | OCPU count of each OpenSearch Dashboards node. | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_remote_reindex_sources"></a> [remote\_reindex\_sources](#input\_remote\_reindex\_sources) | Remote clusters trusted for reindex. Provider 9.11.0 added remote\_reindex\_trust\_config. Leave empty to disable remote reindex. | <pre>list(object({<br/>    ca_bundle_id           = string<br/>    endpoint               = string<br/>    certificate_id         = optional(string)<br/>    endpoint_resolution_ip = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_master_user_name"></a> [security\_master\_user\_name](#input\_security\_master\_user\_name) | Master user name used when security\_mode is ENFORCING. | `string` | n/a | yes |
| <a name="input_security_master_user_password_hash"></a> [security\_master\_user\_password\_hash](#input\_security\_master\_user\_password\_hash) | OpenSearch password hash of the master user. Pass a hash, not the plaintext password. | `string` | n/a | yes |
| <a name="input_security_mode"></a> [security\_mode](#input\_security\_mode) | Security mode of the cluster. | `string` | `"ENFORCING"` | no |
| <a name="input_software_version"></a> [software\_version](#input\_software\_version) | OpenSearch software version, for example 2.15.0. | `string` | n/a | yes |
| <a name="input_subnet_compartment_id"></a> [subnet\_compartment\_id](#input\_subnet\_compartment\_id) | Compartment OCID of the subnet. Leave null to use compartment\_id. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the subnet for the cluster. | `string` | n/a | yes |
| <a name="input_vcn_compartment_id"></a> [vcn\_compartment\_id](#input\_vcn\_compartment\_id) | Compartment OCID of the VCN. Leave null to use compartment\_id. | `string` | `null` | no |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID of the VCN for the cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | OCID of the OpenSearch cluster. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | API fully qualified domain name of the OpenSearch cluster. |
| <a name="output_opendashboard_private_ip"></a> [opendashboard\_private\_ip](#output\_opendashboard\_private\_ip) | Private IP of OpenSearch Dashboards. |
<!-- END_TF_DOCS -->
