variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the logging resources will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
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

  validation {
    condition = alltrue([
      for log in var.logs : contains(["CUSTOM", "SERVICE"], log.log_type)
    ])
    error_message = "log_type must be one of: CUSTOM, SERVICE"
  }

  validation {
    condition = alltrue([
      for log in var.logs : log.retention_duration >= 1 && log.retention_duration <= 180
    ])
    error_message = "retention_duration must be between 1 and 180 days"
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
