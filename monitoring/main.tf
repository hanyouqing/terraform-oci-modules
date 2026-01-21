resource "oci_monitoring_alarm" "this" {
  for_each = var.alarms

  compartment_id        = var.compartment_id
  display_name          = each.value.display_name
  is_enabled            = each.value.is_enabled
  metric_compartment_id = each.value.metric_compartment_id
  namespace             = each.value.namespace
  query                 = each.value.query
  severity              = each.value.severity
  message_format        = each.value.message_format
  body                  = each.value.body

  destinations = length(each.value.destinations) > 0 ? each.value.destinations : []

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/monitoring"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
}
