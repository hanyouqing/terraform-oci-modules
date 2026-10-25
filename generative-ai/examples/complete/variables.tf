variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the dedicated AI cluster."
}

variable "cluster_type" {
  type        = string
  description = "HOSTING or FINE_TUNING."
  default     = "HOSTING"
}

variable "unit_count" {
  type        = number
  description = "Number of capacity units."
  default     = 1
}

variable "unit_shape" {
  type        = string
  description = "Unit shape that matches the capacity reservation."
}

variable "capacity_reservation_id" {
  type        = string
  description = "OCID of the Generative AI capacity reservation."
}
