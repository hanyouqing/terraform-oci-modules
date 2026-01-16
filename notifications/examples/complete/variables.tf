variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "topics" {
  type = map(object({
    name        = string
    description = string
  }))
  description = "Notification topics"
  default     = {}
}

variable "subscriptions" {
  type = map(object({
    topic_key = string
    protocol  = string
    endpoint  = string
  }))
  description = "Subscriptions"
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
