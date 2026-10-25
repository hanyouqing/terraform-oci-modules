variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "email_endpoint" {
  type        = string
  description = "Email address for notifications"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
