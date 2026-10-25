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
  default     = "public-safety-prod"
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "public-safety"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags for the instance. The namespace must already exist."
  default     = {}
}
