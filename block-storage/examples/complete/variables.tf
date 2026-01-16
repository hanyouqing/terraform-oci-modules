variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "volumes" {
  type = map(object({
    display_name        = string
    availability_domain = string
    size_in_gbs         = number
    vpus_per_gb         = optional(string, "10")
    is_auto_tune_enabled = optional(bool, false)
    backup_policy_id    = optional(string, null)
    backup_type         = optional(string, "FULL")
    freeform_tags       = optional(map(string), {})
    defined_tags        = optional(map(map(string)), {})
  }))
  description = "Block volumes"
  default     = {}
}

variable "create_backups" {
  type        = bool
  description = "Create backups"
  default     = false
}

variable "backup_policies" {
  type = map(object({
    display_name = string
    schedules = list(object({
      backup_type       = string
      period            = string
      retention_seconds = number
      hour_of_day       = number
      day_of_month      = number
      day_of_week       = string
      month             = string
      time_zone         = string
    }))
  }))
  description = "Backup policies"
  default     = {}
}

variable "volume_attachments" {
  type = map(object({
    volume_key      = string
    instance_id     = string
    attachment_type = string
    display_name    = string
    device          = string
    is_read_only    = bool
    is_shareable    = bool
  }))
  description = "Volume attachments"
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

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags"
  default     = {}
}
