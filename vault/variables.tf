variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the vault will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "vault_display_name" {
  type        = string
  description = "Display name for the vault"
  default     = "vault"
}

variable "vault_type" {
  type        = string
  description = "Type of vault: VIRTUAL_PRIVATE or DEFAULT"
  default     = "DEFAULT"

  validation {
    condition     = contains(["VIRTUAL_PRIVATE", "DEFAULT"], var.vault_type)
    error_message = "vault_type must be VIRTUAL_PRIVATE or DEFAULT"
  }
}

variable "keys" {
  type = map(object({
    display_name    = string
    algorithm       = string
    length          = optional(number, null)
    curve_id        = optional(string, null)
    protection_mode = string
  }))
  description = "Map of keys to create"
  default     = {}
}

variable "secrets" {
  type = map(object({
    secret_name    = string
    secret_content = string
    content_type   = string
    key_id         = string
  }))
  description = "Map of secrets to create (secret_name maps to oci_vault_secret.secret_name)"
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
  type        = map(string)
  description = "Defined tags to apply to all resources (KMS/vault resources expect map(string))"
  default     = {}
}
