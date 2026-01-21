variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the vault will be created"
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
    display_name   = string
    secret_content = string
    content_type   = string
    key_id         = string
  }))
  description = "Map of secrets to create"
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
