variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the WAF policy."
}

variable "display_name" {
  type        = string
  description = "Display name of the WAF policy."
  default     = "waf-basic"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
