variable "compartment_id" {
  type        = string
  description = "Compartment OCID."
}

variable "connectors" {
  type = map(object({
    description = optional(string)
    source_kind = string
    target_kind = string
    log_sources = optional(list(object({
      compartment_id = string
      log_group_id   = optional(string)
      log_id         = optional(string)
    })), [])
    source_stream_id          = optional(string)
    source_cursor_kind        = optional(string, "LATEST")
    source_compartment_id     = optional(string)
    metric_namespace          = optional(string)
    plugin_name               = optional(string)
    target_bucket             = optional(string)
    target_namespace          = optional(string)
    target_object_name_prefix = optional(string)
    target_stream_id          = optional(string)
    target_topic_id           = optional(string)
    target_function_id        = optional(string)
    target_log_group_id       = optional(string)
    target_compartment_id     = optional(string)
  }))
  description = "Connectors to create. Empty map is valid for validate-only."
  default     = {}
}
