variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "sender_email" {
  type        = string
  description = "Email address for the sender"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
