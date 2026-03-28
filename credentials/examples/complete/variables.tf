variable "user_id" {
  description = "The OCID of the user to manage credentials for."
  type        = string
}

variable "api_keys" {
  description = "Map of API signing keys to create."
  type = map(object({
    key_value = string
  }))
  default = {}
}

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "production"
}
