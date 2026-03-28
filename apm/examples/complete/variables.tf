variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "is_free_tier" {
  type        = bool
  description = "Whether to use Always Free tier"
  default     = true
}

variable "health_check_url" {
  type        = string
  description = "URL for REST health check monitor"
  default     = "https://app.example.com/health"
}

variable "browser_check_url" {
  type        = string
  description = "URL for browser page load monitor"
  default     = "https://app.example.com"
}

variable "dns_check_target" {
  type        = string
  description = "Domain for DNS resolution monitor"
  default     = "app.example.com"
}

variable "vantage_points" {
  type        = list(string)
  description = "Vantage points for monitors"
  default     = ["OraclePublic-us-ashburn-1"]
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags"
  default     = {}
}
