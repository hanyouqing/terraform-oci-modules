variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the database"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
