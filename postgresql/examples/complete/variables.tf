variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the database system."
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the database endpoint."
}

variable "db_version" {
  type        = string
  description = "PostgreSQL major version. Changing it upgrades in place."
  default     = "14"
}

variable "instance_ocpu_count" {
  type        = number
  description = "OCPU count of the flexible node."
  default     = 2
}

variable "instance_memory_size_in_gbs" {
  type        = number
  description = "Memory in gigabytes of the flexible node."
  default     = 32
}

variable "nsg_ids" {
  type        = set(string)
  description = "Network security groups for the database endpoint."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "Vault key OCID for storage encryption. Leave null for Oracle-managed encryption."
  default     = null
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
