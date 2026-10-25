variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the WAF policy."
}

variable "display_name" {
  type        = string
  description = "Display name of the WAF policy."
  default     = "waf-basic"
}
