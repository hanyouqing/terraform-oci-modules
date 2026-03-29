# NoSQL Database Module

This module creates and manages Oracle NoSQL Database tables and secondary indexes in Oracle Cloud Infrastructure.

## Features

- Create NoSQL tables with DDL statements
- Configurable table limits (read/write units, storage)
- PROVISIONED and ON_DEMAND capacity modes
- Secondary indexes with JSON path support
- Auto-reclaimable tables for dev/test
- Comprehensive tagging support

## Always Free Limits

- **Tables**: Up to 3 per tenancy
- **Storage**: 25 GB per table
- **Read Units**: 133 million per month (across all tables)
- **Write Units**: 133 million per month (across all tables)

## Usage

```hcl
module "nosql_database" {
  source = "../nosql-database"

  compartment_id = var.compartment_id

  tables = {
    users = {
      name          = "users"
      ddl_statement = "CREATE TABLE users (id INTEGER, name STRING, email STRING, PRIMARY KEY (id))"

      # Always Free defaults
      max_read_units     = 50
      max_write_units    = 50
      max_storage_in_gbs = 25
      capacity_mode      = "PROVISIONED"
    }
  }

  indexes = {
    users-email = {
      table_key = "users"
      name      = "idx_users_email"
      keys = [
        { column_name = "email" }
      ]
    }
  }

  project     = "my-project"
  environment = "development"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| oci | ~> 7.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment | `string` | n/a | yes |
| tables | Map of NoSQL tables to create | `map(object)` | `{}` | no |
| indexes | Map of secondary indexes to create | `map(object)` | `{}` | no |
| project | Project name for tagging | `string` | `"oci-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| freeform_tags | Freeform tags for all resources | `map(string)` | `{}` | no |
| defined_tags | Defined tags for all resources | `map(map(string))` | `{}` | no |

### Table Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| name | Table name | `string` | — |
| ddl_statement | DDL CREATE TABLE statement | `string` | — |
| max_read_units | Max sustained read throughput | `number` | `50` |
| max_write_units | Max sustained write throughput | `number` | `50` |
| max_storage_in_gbs | Max storage in GB | `number` | `25` |
| capacity_mode | PROVISIONED or ON_DEMAND | `string` | `"PROVISIONED"` |
| is_auto_reclaimable | Reclaim after idle period | `bool` | `false` |

### Index Object

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| table_key | Key referencing a table in `tables` | `string` | — |
| name | Index name | `string` | — |
| is_if_not_exists | Skip if index already exists | `bool` | `true` |
| keys | List of key columns | `list(object)` | — |

## Outputs

| Name | Description |
|------|-------------|
| table_ids | OCIDs of the NoSQL tables |
| table_names | Names of the NoSQL tables |
| table_states | Lifecycle states of the tables |
| table_schemas | Table schemas |
| table_limits | Read/write units and storage per table |
| index_ids | Index names and states |

## Cost Estimate

### Always Free Tier

The following NoSQL Database resources are **free** within Always Free tier limits:
- **3 Tables**: Up to 25 GB storage each
- **Read Throughput**: 133 million read units/month
- **Write Throughput**: 133 million write units/month
- **Indexes**: Included (no additional cost)

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Read Units** | 100 million/month | ~**$1.50** |
| **Write Units** | 100 million/month | ~**$2.50** |
| **Storage** | 25 GB | ~**$25** |
| **Storage** | 100 GB | ~**$100** |
| **Storage** | 1 TB | ~**$1,000** |
| **ON_DEMAND Read** | Per million | ~**$1.50** |
| **ON_DEMAND Write** | Per million | ~**$2.50** |

> **Notes:**
> - Prices vary by region; estimates based on typical OCI pricing
> - Always Free tier is per-tenancy, not per-compartment
> - Indexes share the table's storage quota
> - ON_DEMAND mode bills per-request with no upfront provisioning

### Cost Optimization Tips

1. **Use Always Free tier** (3 tables, 25 GB each) for dev/test
2. **Use PROVISIONED mode** for predictable workloads (lower cost)
3. **Right-size read/write units** based on monitoring data
4. **Enable auto-reclaimable** for temporary/dev tables
5. **Monitor throttling** to detect under-provisioning without over-spending

## Examples

- [Basic](examples/basic/) — Single Always Free table
- [Complete](examples/complete/) — Multiple tables with indexes and ON_DEMAND mode

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_nosql_index.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/nosql_index) | resource |
| [oci_nosql_table.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/nosql_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where NoSQL tables will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_indexes"></a> [indexes](#input\_indexes) | Map of secondary indexes to create on NoSQL tables. table\_key references a key in the tables variable. | <pre>map(object({<br/>    table_key        = string<br/>    name             = string<br/>    is_if_not_exists = optional(bool, true)<br/><br/>    keys = list(object({<br/>      column_name     = string<br/>      json_field_type = optional(string, null)<br/>      json_path       = optional(string, null)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | Map of NoSQL tables to create. Always Free: 3 tables, 25 GB/table, 133M reads+writes/month. | <pre>map(object({<br/>    name          = string<br/>    ddl_statement = string<br/><br/>    # Table limits (defaults are conservative Always Free values)<br/>    max_read_units     = optional(number, 50)<br/>    max_write_units    = optional(number, 50)<br/>    max_storage_in_gbs = optional(number, 25)<br/>    capacity_mode      = optional(string, "PROVISIONED")<br/><br/>    is_auto_reclaimable = optional(bool, false)<br/>    freeform_tags       = optional(map(string), {})<br/>    defined_tags        = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_index_ids"></a> [index\_ids](#output\_index\_ids) | Names and states of the NoSQL indexes |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | OCIDs of the NoSQL tables |
| <a name="output_table_limits"></a> [table\_limits](#output\_table\_limits) | Table limits (read/write units, storage) for each table |
| <a name="output_table_names"></a> [table\_names](#output\_table\_names) | Names of the NoSQL tables |
| <a name="output_table_schemas"></a> [table\_schemas](#output\_table\_schemas) | Schemas of the NoSQL tables |
| <a name="output_table_states"></a> [table\_states](#output\_table\_states) | Lifecycle states of the NoSQL tables |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for NoSQL Database module |
<!-- END_TF_DOCS -->
