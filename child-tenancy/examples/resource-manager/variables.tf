variable "tenancy_id" {
  type        = string
  description = "OCID of the parent tenancy."
}

variable "tenancy_name" {
  type        = string
  description = "Cloud account name of the child tenancy."
}

variable "home_region" {
  type        = string
  description = "Home region subscribed by the parent tenancy."
}

variable "admin_email" {
  type        = string
  description = "Administrator email for the child tenancy."
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
