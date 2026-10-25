variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the dedicated AI cluster."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "cluster_type" {
  type        = string
  description = "Dedicated AI cluster type."

  validation {
    condition     = contains(["HOSTING", "FINE_TUNING"], var.cluster_type)
    error_message = "cluster_type must be HOSTING or FINE_TUNING."
  }
}

variable "unit_count" {
  type        = number
  description = "Number of capacity units in the cluster."

  validation {
    condition     = var.unit_count >= 1
    error_message = "unit_count must be at least 1."
  }
}

variable "unit_shape" {
  type        = string
  description = "Unit shape available for this cluster type in the target region."

  validation {
    condition     = length(var.unit_shape) > 0
    error_message = "unit_shape must be set."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the dedicated AI cluster."
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the dedicated AI cluster."
  default     = null
}

variable "capacity_reservation_id" {
  type        = string
  description = "OCID of a Generative AI capacity reservation to bring to this dedicated AI cluster. Provider 9.11.0 added this argument. Leave null to consume on-demand capacity."
  default     = null

  validation {
    condition     = var.capacity_reservation_id == null ? true : can(regex("^ocid1\\.[a-z0-9]+\\.oc1\\.", var.capacity_reservation_id))
    error_message = "capacity_reservation_id must be an OCID."
  }
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
  description = "Defined tags applied to the cluster."
  default     = {}
}
