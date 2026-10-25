resource "oci_sch_service_connector" "this" {
  for_each = var.connectors

  compartment_id = var.compartment_id
  display_name   = each.key
  description    = each.value.description

  source {
    kind        = each.value.source_kind
    stream_id   = each.value.source_kind == "streaming" ? each.value.source_stream_id : null
    plugin_name = each.value.source_kind == "plugin" ? each.value.plugin_name : null

    dynamic "cursor" {
      for_each = each.value.source_kind == "streaming" ? [each.value.source_cursor_kind] : []
      content {
        kind = cursor.value
      }
    }

    dynamic "log_sources" {
      for_each = each.value.source_kind == "logging" ? each.value.log_sources : []
      content {
        compartment_id = log_sources.value.compartment_id
        log_group_id   = log_sources.value.log_group_id
        log_id         = log_sources.value.log_id
      }
    }

    dynamic "monitoring_sources" {
      for_each = each.value.source_kind == "monitoring" ? [1] : []
      content {
        compartment_id = coalesce(each.value.source_compartment_id, var.compartment_id)
      }
    }
  }

  target {
    kind = each.value.target_kind

    bucket             = each.value.target_kind == "objectStorage" ? each.value.target_bucket : null
    namespace          = each.value.target_kind == "objectStorage" ? each.value.target_namespace : null
    object_name_prefix = each.value.target_kind == "objectStorage" ? each.value.target_object_name_prefix : null
    stream_id          = each.value.target_kind == "streaming" ? each.value.target_stream_id : null
    topic_id           = each.value.target_kind == "notifications" ? each.value.target_topic_id : null
    function_id        = each.value.target_kind == "functions" ? each.value.target_function_id : null
    log_group_id       = each.value.target_kind == "loggingAnalytics" ? each.value.target_log_group_id : null
    compartment_id     = contains(["monitoring", "loggingAnalytics"], each.value.target_kind) ? coalesce(each.value.target_compartment_id, var.compartment_id) : null
    metric_namespace   = each.value.target_kind == "monitoring" ? each.value.metric_namespace : null
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/sch"
    Project     = var.project
    Environment = var.environment
  }
}
