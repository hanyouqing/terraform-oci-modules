variable "compartment_id" {
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
