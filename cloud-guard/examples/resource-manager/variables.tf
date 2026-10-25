
variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID."
}

variable "reporting_region" {
  type        = string
  description = "Home region that stores findings."
  default     = "ap-seoul-1"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
