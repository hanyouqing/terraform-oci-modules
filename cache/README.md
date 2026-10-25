# OCI Cache

Creates one OCI Cache cluster in a private subnet. Clients connect with TLS. Optional users authenticate with IAM. The module does not accept password hashes, because the provider would store them in state.

Oracle recommends `VALKEY_8_1` for a new cluster, and three nodes for a non-sharded primary plus two replicas. A one-node cluster has no replica. Cache is not the system of record, and it is not an Always Free service. The seven solution stacks under `docs/oci-solutions-architect/examples` do not instantiate this module.

Allow TCP 6379 only from the application NSG. Do not open `0.0.0.0/0`.

## Usage

```hcl
module "cache" {
  source = "../cache"

  compartment_id     = var.compartment_id
  display_name       = "app"
  subnet_id          = var.subnet_id
  software_version   = "VALKEY_8_1"
  node_count         = 3
  node_memory_in_gbs = 8
  nsg_ids            = var.nsg_ids
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
| [oci_redis_oci_cache_user.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/redis_oci_cache_user) | resource |
| [oci_redis_redis_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/redis_redis_cluster) | resource |
| [oci_redis_redis_cluster_attach_oci_cache_user.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/redis_redis_cluster_attach_oci_cache_user) | resource |
| [oci_core_subnet.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_mode"></a> [cluster\_mode](#input\_cluster\_mode) | NONSHARDED keeps one primary and optional replicas. SHARDED splits data across an odd number of shards. | `string` | `"NONSHARDED"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the OCI Cache cluster. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the cluster and users. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the OCI Cache cluster. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Total nodes for NONSHARDED, or nodes per shard for SHARDED. Use 3 for a non-sharded primary plus two replicas. | `number` | n/a | yes |
| <a name="input_node_memory_in_gbs"></a> [node\_memory\_in\_gbs](#input\_node\_memory\_in\_gbs) | Memory in gigabytes for each node. OCI Cache allows 2 to 500. A secondary cluster needs at least 8. | `number` | n/a | yes |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | NSG OCIDs for the cluster. Allow TCP 6379 only from the application, and require TLS. | `set(string)` | `[]` | no |
| <a name="input_oci_cache_config_set_id"></a> [oci\_cache\_config\_set\_id](#input\_oci\_cache\_config\_set\_id) | OCID of a custom OCI Cache config set. Null uses the service default for the engine version. | `string` | `null` | no |
| <a name="input_primary_cluster_id"></a> [primary\_cluster\_id](#input\_primary\_cluster\_id) | OCID of the primary cluster when this cluster is a cross-region secondary. Null creates a standalone cluster. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | Odd shard count from 3 to 99. Set only when cluster\_mode is SHARDED. | `number` | `null` | no |
| <a name="input_software_version"></a> [software\_version](#input\_software\_version) | OCI Cache engine version. Oracle recommends VALKEY\_8\_1 for new clusters. Confirm the value in the target region. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the private subnet for the cluster endpoint. | `string` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | IAM OCI Cache users to create and attach. Keys are user names. Password hashes are not accepted. | <pre>map(object({<br/>    description = string<br/>    acl_string  = string<br/>    status      = optional(string, "ON")<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | OCID of the OCI Cache cluster. |
| <a name="output_discovery_fqdn"></a> [discovery\_fqdn](#output\_discovery\_fqdn) | Discovery endpoint FQDN for a sharded cluster. |
| <a name="output_primary_fqdn"></a> [primary\_fqdn](#output\_primary\_fqdn) | Primary endpoint FQDN. Null on a sharded cluster. |
| <a name="output_replicas_fqdn"></a> [replicas\_fqdn](#output\_replicas\_fqdn) | Replica endpoint FQDN. Null on a sharded cluster. |
| <a name="output_user_ids"></a> [user\_ids](#output\_user\_ids) | OCIDs of the IAM OCI Cache users, keyed by user name. |
<!-- END_TF_DOCS -->
