variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the Security Zone."
}

variable "display_name" {
  type        = string
  description = "Display name of the Security Zone."
  default     = "security-zone-demo"
}

variable "security_zone_recipe_id" {
  type        = string
  description = "Existing recipe OCID. Null creates a recipe from security_policies."
  default     = null
}

variable "security_policies" {
  type        = list(string)
  description = "Policy OCIDs when creating a recipe."
  default     = []
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
