
variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID."
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
