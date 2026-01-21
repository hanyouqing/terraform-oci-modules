resource "oci_logging_log_group" "this" {
  for_each = var.log_groups

  compartment_id = var.compartment_id
  display_name   = each.value.display_name
  description    = each.value.description

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/logging"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
}

resource "oci_logging_log" "this" {
  for_each = var.logs

  display_name       = each.value.display_name
  log_group_id       = oci_logging_log_group.this[each.value.log_group_key].id
  log_type           = each.value.log_type
  is_enabled         = each.value.is_enabled
  retention_duration = each.value.retention_duration

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/logging/log"
    }
  )
}
