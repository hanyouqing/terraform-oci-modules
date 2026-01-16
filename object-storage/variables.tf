variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the buckets will be created"
}

variable "region" {
  type        = string
  description = "OCI region for bucket URIs"
  default     = ""
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
  description = "Map of buckets to create"
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
  description = "Map of lifecycle policies to create"
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
  description = "Map of pre-authenticated requests to create"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
