variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the monitoring alarms will be created"
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
