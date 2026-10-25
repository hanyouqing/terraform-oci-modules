variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID. Data Safe configuration is a tenancy resource."

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.", var.tenancy_ocid))
    error_message = "tenancy_ocid must be a tenancy OCID."
  }
}

variable "is_enabled" {
  type        = bool
  description = "Enable Data Safe for the tenancy."
  default     = true
}

variable "compartment_id" {
  type        = string
  description = "Compartment for the private endpoint and target databases. Required when private_endpoint or target_databases is set."
  default     = null
}

variable "private_endpoint" {
  type = object({
    display_name = string
    subnet_id    = string
    vcn_id       = string
    nsg_ids      = optional(set(string), [])
  })
  description = "Private endpoint used to reach databases that have no public IP. Null skips it."
  default     = null
}

variable "target_databases" {
  type = map(object({
    user_name              = string
    autonomous_database_id = string
  }))
  description = "Autonomous Databases to register. Each key must exist in target_database_passwords. The provider stores the password in state."
  default     = {}
}

variable "target_database_passwords" {
  type        = map(string)
  description = "Passwords for target_databases, keyed by the same name. Sensitive. The Data Safe API requires the password on the target resource, so it is stored in state."
  sensitive   = true
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to the private endpoint and targets."
  default     = {}
}

check "private_endpoint_has_compartment" {
  assert {
    condition     = var.private_endpoint == null || var.compartment_id != null
    error_message = "Set compartment_id when private_endpoint is set."
  }
}

check "targets_use_private_endpoint_and_passwords" {
  assert {
    condition = length(var.target_databases) == 0 || (
      var.private_endpoint != null &&
      alltrue([for name, _ in var.target_databases : contains(keys(var.target_database_passwords), name)])
    )
    error_message = "Each target database needs a private endpoint and a matching entry in target_database_passwords."
  }
}
