variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the connection."
}

variable "connection_type" {
  type        = string
  description = "GoldenGate connection type."
  default     = "POSTGRESQL"
}

variable "technology_type" {
  type        = string
  description = "GoldenGate technology type."
  default     = "POSTGRESQL_SERVER"
}

variable "username" {
  type        = string
  description = "Database username."
  default     = "ggadmin"
}

variable "host" {
  type        = string
  description = "Private hostname or IP of the database."
}

variable "port" {
  type        = number
  description = "Database port."
  default     = 5432
}

variable "database_name" {
  type        = string
  description = "Database name."
  default     = "app"
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the private connection."
}

variable "password_secret_id" {
  type        = string
  description = "Vault secret OCID for the database password."
}
