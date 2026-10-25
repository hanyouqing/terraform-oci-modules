variable "compartment_id" {
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
