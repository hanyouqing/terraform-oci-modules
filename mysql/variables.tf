variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the MySQL system will be created"
}

variable "mysql_systems" {
  type = map(object({
    display_name        = string
    availability_domain = string
    shape_name          = string
    subnet_id           = string
    admin_username      = string
    admin_password      = string
    mysql_version       = optional(string, "8.0.35")
    configuration_id    = optional(string, null)
    data_storage_size_in_gb = number
    backup_policy = object({
      is_enabled        = optional(bool, true)
      retention_in_days = optional(number, 7)
      window_start_time = optional(string, "02:00")
    })
  }))
  description = "Map of MySQL systems to create"
  default     = {}

  validation {
    condition = alltrue([
      for mysql in var.mysql_systems : mysql.data_storage_size_in_gb >= 50 && mysql.data_storage_size_in_gb <= 50
    ])
    error_message = "For Always Free, data_storage_size_in_gb must be 50 GB"
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
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
