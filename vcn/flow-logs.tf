resource "oci_logging_log_group" "vcn_flow_logs" {
  count = var.enable_vcn_flow_logs ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = "${var.vcn_display_name}-flow-logs"
  description    = "VCN Flow Logs for ${var.vcn_display_name}"

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/flow-logs/log-group"
    }
  )
}

resource "oci_logging_log" "vcn_flow_log" {
  count = var.enable_vcn_flow_logs ? 1 : 0

  display_name       = "${var.vcn_display_name}-flow-log"
  log_group_id       = oci_logging_log_group.vcn_flow_logs[0].id
  log_type           = "SERVICE"
  is_enabled         = true
  retention_duration = var.vcn_flow_log_retention_duration

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/flow-logs/log"
    }
  )
}

resource "oci_core_vcn_flow_log" "this" {
  count = var.enable_vcn_flow_logs ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = "${var.vcn_display_name}-flow-log"
  vcn_id         = oci_core_vcn.this.id
  log_group_id   = oci_logging_log_group.vcn_flow_logs[0].id
  log_id         = oci_logging_log.vcn_flow_log[0].id

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/flow-logs/vcn-flow-log"
    }
  )
}
