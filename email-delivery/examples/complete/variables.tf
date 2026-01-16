variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "senders" {
  type = map(object({
    email_address = string
  }))
  description = "Email senders"
  default     = {}
}

variable "suppressions" {
  type = map(object({
    email_address = string
  }))
  description = "Email suppressions"
  default     = {}
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
