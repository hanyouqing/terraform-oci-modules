variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the monitoring alarms will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "alarms" {
  type = map(object({
    display_name          = string
    is_enabled            = optional(bool, true)
    metric_compartment_id = string
    namespace             = string
    query                 = string
    severity              = string
    message_format        = optional(string, "ONS_OPTIMIZED")
    body                  = optional(string, "")
    destinations          = optional(list(string), [])
  }))
  description = "Map of monitoring alarms to create"
  default     = {}

  validation {
    condition = alltrue([
      for alarm in var.alarms : contains(["CRITICAL", "ERROR", "WARNING", "INFO"], alarm.severity)
    ])
    error_message = "severity must be one of: CRITICAL, ERROR, WARNING, INFO"
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : contains(["RAW", "PRETTY_JSON", "ONS_OPTIMIZED"], alarm.message_format)
    ])
    error_message = "message_format must be one of: RAW, PRETTY_JSON, ONS_OPTIMIZED"
  }
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources"
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all resources"
  default     = {}
}
