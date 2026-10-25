variable "compartment_id" {
  type        = string
  description = "Compartment OCID that owns the service connectors."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
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
  description = "Service connectors keyed by display name. source_kind and target_kind use Service Connector Hub values such as logging, streaming, objectStorage, notifications, functions."
  default     = {}

  validation {
    condition = alltrue([
      for name, c in var.connectors :
      contains(["logging", "streaming", "monitoring", "plugin"], c.source_kind) &&
      contains(["objectStorage", "streaming", "notifications", "functions", "loggingAnalytics", "monitoring"], c.target_kind)
    ])
    error_message = "Each connector needs a supported source_kind and target_kind."
  }
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to connectors."
  default     = {}
}
