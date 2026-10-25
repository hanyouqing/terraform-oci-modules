variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the email delivery resources will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "senders" {
  type = map(object({
    email_address = string
  }))
  description = "Map of email senders to create"
  default     = {}

  validation {
    condition = alltrue([
      for sender in var.senders : can(regex("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$", sender.email_address))
    ])
    error_message = "All sender email_address values must be valid email addresses"
  }
}

variable "suppressions" {
  type = map(object({
    email_address = string
  }))
  description = "Map of email suppressions to create"
  default     = {}

  validation {
    condition = alltrue([
      for suppression in var.suppressions : can(regex("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$", suppression.email_address))
    ])
    error_message = "All suppression email_address values must be valid email addresses"
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
