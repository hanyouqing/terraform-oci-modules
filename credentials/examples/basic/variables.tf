variable "user_id" {
  description = "The OCID of the user to manage credentials for."
  type        = string
}

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "development"
}
