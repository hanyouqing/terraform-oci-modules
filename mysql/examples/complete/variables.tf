variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "mysql_systems" {
  type = map(object({
    display_name            = string
    availability_domain     = string
    shape_name              = string
    subnet_id               = string
    admin_username          = string
    admin_password          = string
    mysql_version           = optional(string, "8.0.35")
    configuration_id        = optional(string, null)
    data_storage_size_in_gb = number
    backup_policy = object({
      is_enabled        = optional(bool, true)
      retention_in_days = optional(number, 7)
      window_start_time = optional(string, "02:00")
    })
  }))
  description = "MySQL systems"
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
