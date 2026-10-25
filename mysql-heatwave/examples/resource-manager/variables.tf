variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet"
}

variable "admin_password" {
  type        = string
  description = "Admin password"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
