
variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID."
}

variable "reporting_region" {
  type        = string
  description = "Home region that stores findings."
  default     = "ap-seoul-1"
}

variable "targets" {
  type = map(object({
    compartment_id       = string
    target_resource_id   = string
    target_resource_type = optional(string, "COMPARTMENT")
    detector_recipe_ids  = list(string)
    responder_recipe_ids = optional(list(string), [])
  }))
  description = "Compartment targets and existing recipe OCIDs."
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "cloud-guard"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
