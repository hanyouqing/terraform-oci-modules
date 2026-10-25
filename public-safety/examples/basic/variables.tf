variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the Public Safety instance."
}

variable "identity_domain_url" {
  type        = string
  description = "HTTPS URL of the identity domain bound to the instance."
}

variable "admin_identity_domain_user_id" {
  type        = string
  description = "OCID of the identity-domain administrator."
}

variable "display_name" {
  type        = string
  description = "Display name of the instance."
  default     = "public-safety-basic"
}
