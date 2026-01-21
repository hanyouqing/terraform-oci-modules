variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the logging resources will be created"
}

variable "log_groups" {
  type = map(object({
    display_name = string
    description  = string
  }))
  description = "Map of log groups to create"
  default     = {}
}

variable "logs" {
  type = map(object({
    log_group_key      = string
    display_name       = string
    log_type           = string
    is_enabled         = bool
    retention_duration = number
  }))
  description = "Map of logs to create"
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
