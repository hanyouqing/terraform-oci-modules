resource "oci_logging_log_group" "this" {
  for_each = var.log_groups

  compartment_id = var.compartment_id
  display_name   = each.value.display_name
  description    = each.value.description

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/logging"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_logging_log" "this" {
  for_each = var.logs

  display_name       = each.value.display_name
  log_group_id       = oci_logging_log_group.this[each.value.log_group_key].id
  log_type           = each.value.log_type
  is_enabled         = each.value.is_enabled
  retention_duration = each.value.retention_duration

  dynamic "configuration" {
    for_each = each.value.configuration != null ? [each.value.configuration] : []
    content {
      compartment_id = configuration.value.compartment_id != null ? configuration.value.compartment_id : var.compartment_id

      source {
        category    = configuration.value.source.category
        resource    = configuration.value.source.resource
        service     = configuration.value.source.service
        source_type = configuration.value.source.source_type
        parameters  = length(configuration.value.source.parameters) > 0 ? configuration.value.source.parameters : null
      }
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/logging/log"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}
