resource "oci_logging_log_group" "vcn_flow_logs" {
  count = var.enable_vcn_flow_logs ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = "${var.vcn_display_name}-flow-logs"
  description    = "VCN Flow Logs for ${var.vcn_display_name}"

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/flow-logs/log-group"
    }
  )
}

resource "oci_logging_log" "vcn_flow_log" {
  count = var.enable_vcn_flow_logs ? 1 : 0

  display_name       = "${var.vcn_display_name}-flow-log"
  log_group_id       = oci_logging_log_group.vcn_flow_logs[0].id
  log_type           = "SERVICE"
  is_enabled         = var.vcn_flow_log_enabled
  retention_duration = var.vcn_flow_log_retention_duration

  configuration {
    source {
      source_type = "OCISERVICE"
      category    = "all"
      service     = "flowlogs"
      resource    = oci_core_vcn.this.id
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/flow-logs/log"
    }
  )
}
