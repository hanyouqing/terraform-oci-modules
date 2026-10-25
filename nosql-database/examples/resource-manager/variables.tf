variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
