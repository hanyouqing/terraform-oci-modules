variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the notification resources will be created"
}

variable "topics" {
  type = map(object({
    name        = string
    description = string
  }))
  description = "Map of notification topics to create"
  default     = {}
}

variable "subscriptions" {
  type = map(object({
    topic_key = string
    protocol  = string
    endpoint  = string
  }))
  description = "Map of subscriptions to create"
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
