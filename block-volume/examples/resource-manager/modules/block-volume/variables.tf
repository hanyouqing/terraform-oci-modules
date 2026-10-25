variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the block volumes will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.", var.tenancy_ocid))
    error_message = "tenancy_ocid must be a valid OCI tenancy OCID."
  }
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
    defined_tags         = optional(map(string), {})
  }))
  description = "Map of block volumes to create"
  default     = {}

  validation {
    condition = alltrue([
      for v in var.volumes : v.size_in_gbs >= 50 && v.size_in_gbs <= 200
    ])
    error_message = "Each volume size must be between 50 and 200 GB for Always Free (total limit 200 GB)"
  }

  validation {
    condition = alltrue([
      for v in var.volumes : contains(["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "110", "120"], v.vpus_per_gb)
    ])
    error_message = "vpus_per_gb must be a value between 0 and 120 in increments of 10."
  }

  validation {
    condition = alltrue([
      for v in var.volumes : contains(["FULL", "INCREMENTAL"], v.backup_type)
    ])
    error_message = "backup_type must be FULL or INCREMENTAL."
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

  validation {
    condition = alltrue(flatten([
      for p in var.backup_policies : [
        for s in p.schedules : contains(["FULL", "INCREMENTAL"], s.backup_type)
      ]
    ]))
    error_message = "backup_policies schedules backup_type must be FULL or INCREMENTAL."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.backup_policies : [
        for s in p.schedules : contains(["ONE_DAY", "ONE_WEEK", "ONE_MONTH", "ONE_YEAR"], s.period)
      ]
    ]))
    error_message = "backup_policies schedules period must be one of: ONE_DAY, ONE_WEEK, ONE_MONTH, ONE_YEAR."
  }

  validation {
    condition = alltrue(flatten([
      for p in var.backup_policies : [
        for s in p.schedules : s.hour_of_day >= 0 && s.hour_of_day <= 23
      ]
    ]))
    error_message = "backup_policies schedules hour_of_day must be between 0 and 23."
  }
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

  validation {
    condition = alltrue([
      for a in var.volume_attachments : contains(["iscsi", "paravirtualized"], a.attachment_type)
    ])
    error_message = "attachment_type must be iscsi or paravirtualized."
  }

  validation {
    condition = alltrue([
      for a in var.volume_attachments : can(regex("^ocid1\\.instance\\.oc1\\.", a.instance_id))
    ])
    error_message = "instance_id must be a valid OCI instance OCID."
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
