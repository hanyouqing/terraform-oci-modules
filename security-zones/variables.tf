variable "compartment_id" {
  type        = string
  description = "Compartment OCID that the Security Zone covers."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the Security Zone."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "description" {
  type        = string
  description = "Optional description of the Security Zone."
  default     = null
}

variable "security_zone_recipe_id" {
  type        = string
  description = "Existing Security Zone recipe OCID. Null creates a recipe from security_policies."
  default     = null

  validation {
    condition     = var.security_zone_recipe_id == null || can(regex("^ocid1\\.securityzonessecurityrecipe\\.oc1\\.", var.security_zone_recipe_id)) || can(regex("^ocid1\\.", var.security_zone_recipe_id))
    error_message = "security_zone_recipe_id must be a recipe OCID when set."
  }
}

variable "security_policies" {
  type        = list(string)
  description = "Security policy OCIDs for a new recipe. Required when security_zone_recipe_id is null. List Oracle-managed policies in the target region."
  default     = []
}

variable "recipe_display_name" {
  type        = string
  description = "Display name for a module-created recipe. Null derives from display_name."
  default     = null
}

variable "recipe_description" {
  type        = string
  description = "Description for a module-created recipe."
  default     = "Managed by terraform-oci-modules/security-zones"
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
  description = "Defined tags applied to the zone and recipe."
  default     = {}
}

check "recipe_or_policies" {
  assert {
    condition     = var.security_zone_recipe_id != null || length(var.security_policies) > 0
    error_message = "Provide security_zone_recipe_id or a non-empty security_policies list."
  }
}
