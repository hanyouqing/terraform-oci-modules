
variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID."
}

variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the private endpoint and targets."
}

variable "private_endpoint" {
  type = object({
    display_name = string
    subnet_id    = string
    vcn_id       = string
    nsg_ids      = optional(set(string), [])
  })
  description = "Private endpoint for databases without a public IP."
}

variable "target_databases" {
  type = map(object({
    user_name              = string
    autonomous_database_id = string
  }))
  description = "Autonomous Databases to register."
  default     = {}
}

variable "target_database_passwords" {
  type        = map(string)
  description = "Passwords keyed by target name. The provider stores them in state."
  sensitive   = true
  default     = {}
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "data-safe"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
