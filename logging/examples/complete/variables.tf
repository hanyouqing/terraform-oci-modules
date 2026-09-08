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
    log_group_key      = string
    display_name       = string
    log_type           = string
    is_enabled         = optional(bool, true)
    retention_duration = optional(number, 30)
    configuration = optional(object({
      source = object({
        category    = string
        resource    = string
        service     = string
        source_type = optional(string, "OCISERVICE")
        parameters  = optional(map(string), {})
      })
      compartment_id = optional(string, null)
    }), null)
  }))
  description = "Logs (SERVICE logs require configuration)"
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
