variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the resource."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "identity_domain_url" {
  type        = string
  description = "URL of the identity domain associated with the Public Safety instance. Example: https://idcs-1234567890.identity.oraclecloud.com."

  validation {
    condition     = can(regex("^https://", var.identity_domain_url))
    error_message = "identity_domain_url must be an https URL."
  }
}

variable "admin_identity_domain_user_id" {
  type        = string
  description = "OCID of the identity-domain user that initially administers the Public Safety instance."

  validation {
    condition     = can(regex("^ocid1\\.user\\.oc1\\.", var.admin_identity_domain_user_id))
    error_message = "admin_identity_domain_user_id must be an identity user OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the Public Safety instance."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
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
  description = "Defined tags applied to resources that accept them."
  default     = {}
}
