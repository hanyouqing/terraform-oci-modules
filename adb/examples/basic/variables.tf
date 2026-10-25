variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the database"
  sensitive   = true
}
