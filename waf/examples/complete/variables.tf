variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the WAF policy and firewall."
}

variable "display_name" {
  type        = string
  description = "Display name of the WAF policy and firewall."
  default     = "waf-complete"
}

variable "load_balancer_id" {
  type        = string
  description = "OCID of the flexible load balancer to protect."
}

variable "protection_capabilities" {
  type = list(object({
    key     = string
    version = number
  }))
  description = "Protection capabilities confirmed for the target region."
}

variable "rate_limit" {
  type = object({
    period_in_seconds = number
    requests_limit    = number
  })
  description = "Optional request rate limit."
  default     = null
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "waf"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
