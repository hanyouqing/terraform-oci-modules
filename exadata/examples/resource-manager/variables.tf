
variable "compartment_ocid" {
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
  default     = "exadata-basic"
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

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
