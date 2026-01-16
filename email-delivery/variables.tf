variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the email delivery resources will be created"
}

variable "senders" {
  type = map(object({
    email_address = string
  }))
  description = "Map of email senders to create"
  default     = {}
}

variable "suppressions" {
  type = map(object({
    email_address = string
  }))
  description = "Map of email suppressions to create"
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
