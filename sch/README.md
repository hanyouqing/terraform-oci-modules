# Service Connector Hub

Creates Service Connector Hub connectors that route Logging, Streaming, or Monitoring sources to Object Storage, Streaming, Notifications, Functions, or Logging Analytics. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "sch" {
  source = "../sch"

  compartment_id = var.compartment_id
  connectors = {
    flow-to-bucket = {
      source_kind = "logging"
      target_kind = "objectStorage"
      log_sources = [{
        compartment_id = var.compartment_id
        log_group_id   = var.log_group_id
      }]
      target_bucket    = var.bucket_name
      target_namespace = var.namespace
    }
  }
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
| [oci_sch_service_connector.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/sch_service_connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID that owns the service connectors. | `string` | n/a | yes |
| <a name="input_connectors"></a> [connectors](#input\_connectors) | Service connectors keyed by display name. source\_kind and target\_kind use Service Connector Hub values such as logging, streaming, objectStorage, notifications, functions. | <pre>map(object({<br/>    description = optional(string)<br/>    source_kind = string<br/>    target_kind = string<br/>    log_sources = optional(list(object({<br/>      compartment_id = string<br/>      log_group_id   = optional(string)<br/>      log_id         = optional(string)<br/>    })), [])<br/>    source_stream_id          = optional(string)<br/>    source_cursor_kind        = optional(string, "LATEST")<br/>    source_compartment_id     = optional(string)<br/>    metric_namespace          = optional(string)<br/>    plugin_name               = optional(string)<br/>    target_bucket             = optional(string)<br/>    target_namespace          = optional(string)<br/>    target_object_name_prefix = optional(string)<br/>    target_stream_id          = optional(string)<br/>    target_topic_id           = optional(string)<br/>    target_function_id        = optional(string)<br/>    target_log_group_id       = optional(string)<br/>    target_compartment_id     = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to connectors. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connector_ids"></a> [connector\_ids](#output\_connector\_ids) | Service connector OCIDs keyed by display name. |
<!-- END_TF_DOCS -->
