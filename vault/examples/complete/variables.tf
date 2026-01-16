variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "vault_display_name" {
  type        = string
  description = "Vault display name"
  default     = "production-vault"
}

variable "vault_type" {
  type        = string
  description = "Vault type"
  default     = "DEFAULT"
}

variable "keys" {
  type = map(object({
    display_name   = string
    algorithm      = string
    length         = optional(number, null)
    curve_id       = optional(string, null)
    protection_mode = string
  }))
  description = "Keys"
  default     = {}
}

variable "secrets" {
  type = map(object({
    display_name  = string
    secret_content = string
    content_type   = string
    key_id         = string
  }))
  description = "Secrets"
  default     = {}
  sensitive   = true
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
