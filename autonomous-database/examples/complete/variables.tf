variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "databases" {
  type = map(object({
    db_name                                        = string
    display_name                                   = string
    admin_password                                 = string
    db_workload                                    = string
    is_free_tier                                   = bool
    license_model                                  = string
    cpu_core_count                                 = number
    data_storage_size_in_tbs                       = number
    is_auto_scaling_enabled                        = optional(bool, false)
    is_dedicated                                   = optional(bool, false)
    is_mtls_connection_required                    = optional(bool, false)
    is_preview_version_with_service_terms_accepted = optional(bool, false)
    nsg_ids                                        = optional(list(string), [])
    private_endpoint_label                         = optional(string, null)
    subnet_id                                      = optional(string, null)
    vcn_id                                         = optional(string, null)
    whitelisted_ips                                = optional(list(string), [])
    freeform_tags                                  = optional(map(string), {})
    defined_tags                                   = optional(map(map(string)), {})
  }))
  description = "Autonomous Databases"
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
