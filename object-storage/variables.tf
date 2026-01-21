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
    name          = string
    namespace     = optional(string, null)
    access_type   = optional(string, "NoPublicAccess")
    storage_tier  = optional(string, "Standard")
    versioning    = optional(string, "Disabled")
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

  validation {
    condition = alltrue([
      for policy in var.lifecycle_policies : contains(keys(var.buckets), policy.bucket_key)
    ])
    error_message = "All lifecycle_policies must reference an existing bucket_key"
  }

  validation {
    condition = alltrue([
      for policy in var.lifecycle_policies : contains(["ARCHIVE", "DELETE"], policy.action)
    ])
    error_message = "action must be either 'ARCHIVE' or 'DELETE'"
  }

  validation {
    condition = alltrue([
      for policy in var.lifecycle_policies : contains(["DAYS", "YEARS"], policy.time_unit)
    ])
    error_message = "time_unit must be either 'DAYS' or 'YEARS'"
  }
}

variable "preauth_requests" {
  type = map(object({
    bucket_key   = string
    name         = string
    object       = string
    access_type  = string
    time_expires = string
  }))
  description = "Map of pre-authenticated requests to create"
  default     = {}

  validation {
    condition = alltrue([
      for req in var.preauth_requests : contains(keys(var.buckets), req.bucket_key)
    ])
    error_message = "All preauth_requests must reference an existing bucket_key"
  }

  validation {
    condition = alltrue([
      for req in var.preauth_requests : contains(["ObjectRead", "ObjectWrite", "ObjectReadWrite", "AnyObjectRead", "AnyObjectWrite", "AnyObjectReadWrite"], req.access_type)
    ])
    error_message = "access_type must be one of: ObjectRead, ObjectWrite, ObjectReadWrite, AnyObjectRead, AnyObjectWrite, AnyObjectReadWrite"
  }
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
