variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the Autonomous Database will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
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
    is_mtls_connection_required                    = optional(bool, true)
    is_preview_version_with_service_terms_accepted = optional(bool, false)
    nsg_ids                                        = optional(list(string), [])
    private_endpoint_label                         = optional(string, null)
    subnet_id                                      = optional(string, null)
    whitelisted_ips                                = optional(list(string), [])
    freeform_tags                                  = optional(map(string), {})
    defined_tags                                   = optional(map(string), {})
  }))
  description = "Map of Autonomous Databases to create. For Always Free, is_free_tier=true, cpu_core_count=1, data_storage_size_in_tbs=1."
  default     = {}

  validation {
    condition = alltrue([
      for db in var.databases : db.is_free_tier ? (db.cpu_core_count == 1 && db.data_storage_size_in_tbs == 1) : true
    ])
    error_message = "For Always Free Tier (is_free_tier=true), cpu_core_count must be 1 and data_storage_size_in_tbs must be 1 (OCI mapping)."
  }

  validation {
    condition = alltrue([
      for db in var.databases : contains(["OLTP", "DW", "AJD", "APEX"], db.db_workload)
    ])
    error_message = "db_workload must be one of: OLTP, DW, AJD, APEX."
  }

  validation {
    condition = alltrue([
      for db in var.databases : contains(["LICENSE_INCLUDED", "BRING_YOUR_OWN_LICENSE"], db.license_model)
    ])
    error_message = "license_model must be either 'LICENSE_INCLUDED' or 'BRING_YOUR_OWN_LICENSE'"
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
