variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the DR protection group."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the DR protection group."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "log_bucket" {
  type        = string
  description = "Object Storage bucket name for Full Stack Disaster Recovery logs."

  validation {
    condition     = length(var.log_bucket) > 0
    error_message = "log_bucket must be set."
  }
}

variable "log_namespace" {
  type        = string
  description = "Object Storage namespace for Full Stack Disaster Recovery logs."

  validation {
    condition     = length(var.log_namespace) > 0
    error_message = "log_namespace must be set."
  }
}

variable "association" {
  type = object({
    role        = string
    peer_id     = optional(string)
    peer_region = optional(string)
  })
  description = "Optional peer association. role is PRIMARY or STANDBY. Null creates an unassociated group."
  default     = null

  validation {
    condition     = var.association == null ? true : contains(["PRIMARY", "STANDBY"], var.association.role)
    error_message = "association.role must be PRIMARY or STANDBY."
  }
}

variable "members" {
  type = list(object({
    member_id   = string
    member_type = string
  }))
  description = "Optional members (COMPUTE_INSTANCE, VOLUME_GROUP, AUTONOMOUS_DATABASE, and other Full Stack DR member types). Empty creates the group only."
  default     = []
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
  description = "Defined tags applied to the protection group."
  default     = {}
}
