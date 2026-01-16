variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "log_groups" {
  type = map(object({
    display_name = string
    description  = string
  }))
  description = "Log groups"
  default     = {}
}

variable "logs" {
  type = map(object({
    log_group_key     = string
    display_name      = string
    log_type          = string
    is_enabled        = bool
    retention_duration = number
  }))
  description = "Logs"
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
