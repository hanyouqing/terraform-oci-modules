variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the notification resources will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "topics" {
  type = map(object({
    name        = string
    description = string
  }))
  description = "Map of notification topics to create"
  default     = {}

  validation {
    condition = alltrue([
      for t in var.topics : length(t.name) >= 1 && length(t.name) <= 255 && can(regex("^[a-zA-Z0-9_-]+$", t.name))
    ])
    error_message = "topics name must be 1-255 characters, alphanumeric with hyphens and underscores only."
  }
}

variable "subscriptions" {
  type = map(object({
    topic_key = string
    protocol  = string
    endpoint  = string
  }))
  description = "Map of subscriptions to create"
  default     = {}

  validation {
    condition = alltrue([
      for sub in var.subscriptions : contains(["CUSTOM_HTTPS", "EMAIL", "FAAS", "OSS", "PAGERDUTY", "SLACK", "SMS"], sub.protocol)
    ])
    error_message = "protocol must be one of: CUSTOM_HTTPS, EMAIL, FAAS, OSS, PAGERDUTY, SLACK, SMS"
  }

  validation {
    condition = alltrue([
      for sub in var.subscriptions : length(sub.endpoint) > 0
    ])
    error_message = "subscriptions endpoint must not be empty."
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
  type        = map(string)
  description = "Defined tags to apply to all resources"
  default     = {}
}
