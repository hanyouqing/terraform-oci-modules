
variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID."
}

variable "reporting_region" {
  type        = string
  description = "Home region that stores findings."
  default     = "ap-seoul-1"
}
