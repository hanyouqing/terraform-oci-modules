variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the block volumes will be created"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "volumes" {
  type = map(object({
    display_name         = string
    availability_domain  = string
    size_in_gbs          = number
    vpus_per_gb          = optional(string, "10")
    is_auto_tune_enabled = optional(bool, false)
    backup_policy_id     = optional(string, null)
    backup_type          = optional(string, "FULL")
    freeform_tags        = optional(map(string), {})
    defined_tags         = optional(map(map(string)), {})
  }))
  description = "Map of block volumes to create"
  default     = {}

  validation {
    condition = alltrue([
      for v in var.volumes : v.size_in_gbs >= 50 && v.size_in_gbs <= 200
    ])
    error_message = "Each volume size must be between 50 and 200 GB for Always Free (total limit 200 GB)"
  }
}

variable "create_backups" {
  type        = bool
  description = "Whether to create backups for volumes"
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
  description = "Map of backup policies to create"
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
  description = "Map of volume attachments"
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

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
