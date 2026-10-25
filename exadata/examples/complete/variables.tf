
variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the infrastructure."
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for the infrastructure."
}

variable "display_name" {
  type        = string
  description = "Display name."
  default     = "exadata-complete"
}

variable "shape" {
  type        = string
  description = "Exadata shape available in the region."
}

variable "compute_count" {
  type        = number
  description = "Compute server count."
  default     = 2
}

variable "storage_count" {
  type        = number
  description = "Storage server count."
  default     = 3
}

variable "customer_contact_emails" {
  type        = list(string)
  description = "Maintenance contact emails."
  default     = []
}

variable "vm_cluster" {
  type = object({
    display_name           = string
    hostname               = string
    cpu_core_count         = number
    gi_version             = string
    subnet_id              = string
    backup_subnet_id       = string
    ssh_public_keys        = list(string)
    license_model          = optional(string, "LICENSE_INCLUDED")
    nsg_ids                = optional(set(string), [])
    backup_network_nsg_ids = optional(set(string), [])
  })
  description = "VM cluster on this infrastructure."
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "exadata"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
