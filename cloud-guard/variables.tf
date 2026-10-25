variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID. Cloud Guard configuration is a tenancy resource."

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.", var.tenancy_ocid))
    error_message = "tenancy_ocid must be a tenancy OCID."
  }
}

variable "reporting_region" {
  type        = string
  description = "Home region that stores Cloud Guard findings. Changing it later recreates the reporting setup."

  validation {
    condition     = length(var.reporting_region) > 0
    error_message = "reporting_region must be set."
  }
}

variable "status" {
  type        = string
  description = "ENABLED turns Cloud Guard on for the tenancy."
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.status)
    error_message = "status must be ENABLED or DISABLED."
  }
}

variable "targets" {
  type = map(object({
    compartment_id       = string
    target_resource_id   = string
    target_resource_type = optional(string, "COMPARTMENT")
    detector_recipe_ids  = list(string)
    responder_recipe_ids = optional(list(string), [])
  }))
  description = "Targets to monitor. detector_recipe_ids are existing Oracle-managed or cloned recipe OCIDs. The module does not clone recipes."
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to targets."
  default     = {}
}

check "targets_have_detector_recipes" {
  assert {
    condition = alltrue([
      for target in var.targets : length(target.detector_recipe_ids) > 0 && target.target_resource_type == "COMPARTMENT"
    ])
    error_message = "Each target needs at least one detector recipe and target_resource_type COMPARTMENT."
  }
}
