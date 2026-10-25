variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the dedicated AI cluster."
}

variable "unit_count" {
  type        = number
  description = "Number of capacity units."
  default     = 1
}

variable "unit_shape" {
  type        = string
  description = "Unit shape available for HOSTING in the target region."
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
