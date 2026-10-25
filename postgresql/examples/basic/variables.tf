variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the database system."
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the database endpoint."
}

variable "admin_username" {
  type        = string
  description = "Administrator username."
  default     = "appadmin"
}

variable "admin_password_secret_id" {
  type        = string
  description = "Vault secret OCID that holds the administrator password."
  sensitive   = true
}
