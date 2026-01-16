variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
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
  description = "Monitoring alarms"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default     = {}
}
