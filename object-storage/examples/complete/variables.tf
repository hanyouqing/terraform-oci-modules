variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "region" {
  type        = string
  description = "OCI region"
  default     = "us-ashburn-1"
}

variable "buckets" {
  type = map(object({
    name         = string
    namespace    = optional(string, null)
    access_type  = optional(string, "NoPublicAccess")
    storage_tier = optional(string, "Standard")
    versioning   = optional(string, "Disabled")
    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(map(string)), {})
  }))
  description = "Buckets"
  default     = {}
}

variable "lifecycle_policies" {
  type = map(object({
    bucket_key         = string
    rule_name          = string
    is_enabled         = optional(bool, true)
    action             = string
    inclusion_prefixes = optional(list(string), [])
    inclusion_patterns = optional(list(string), [])
    target             = string
    time_amount        = number
    time_unit          = string
  }))
  description = "Lifecycle policies"
  default     = {}
}

variable "preauth_requests" {
  type = map(object({
    bucket_key  = string
    name        = string
    object      = string
    access_type = string
    time_expires = string
  }))
  description = "Pre-authenticated requests"
  default     = {}
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
