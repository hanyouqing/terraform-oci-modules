variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where NoSQL tables will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "tables" {
  type = map(object({
    name          = string
    ddl_statement = string

    # Table limits (defaults are conservative Always Free values)
    max_read_units     = optional(number, 50)
    max_write_units    = optional(number, 50)
    max_storage_in_gbs = optional(number, 25)
    capacity_mode      = optional(string, "PROVISIONED")

    is_auto_reclaimable = optional(bool, false)
    freeform_tags       = optional(map(string), {})
    defined_tags        = optional(map(string), {})
  }))
  description = "Map of NoSQL tables to create. Always Free: 3 tables, 25 GB/table, 133M reads+writes/month."
  default     = {}

  validation {
    condition = alltrue([
      for t in var.tables : contains(["PROVISIONED", "ON_DEMAND"], t.capacity_mode)
    ])
    error_message = "capacity_mode must be either 'PROVISIONED' or 'ON_DEMAND'."
  }

  validation {
    condition = alltrue([
      for t in var.tables : t.max_storage_in_gbs >= 1 && t.max_storage_in_gbs <= 100000
    ])
    error_message = "max_storage_in_gbs must be between 1 and 100,000."
  }

  validation {
    condition = alltrue([
      for t in var.tables : t.capacity_mode == "ON_DEMAND" || (t.max_read_units >= 1 && t.max_write_units >= 1)
    ])
    error_message = "max_read_units and max_write_units must be >= 1 when capacity_mode is PROVISIONED."
  }
}

variable "indexes" {
  type = map(object({
    table_key        = string
    name             = string
    is_if_not_exists = optional(bool, true)

    keys = list(object({
      column_name     = string
      json_field_type = optional(string, null)
      json_path       = optional(string, null)
    }))
  }))
  description = "Map of secondary indexes to create on NoSQL tables. table_key references a key in the tables variable."
  default     = {}

  validation {
    condition = alltrue([
      for idx in var.indexes : length(idx.keys) >= 1
    ])
    error_message = "Each index must have at least one key column."
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
