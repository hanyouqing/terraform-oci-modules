variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the Exadata infrastructure."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for the Cloud Exadata infrastructure, for example ABcd:AP-SEOUL-1-AD-1."

  validation {
    condition     = length(var.availability_domain) > 0
    error_message = "availability_domain must be set."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the Cloud Exadata infrastructure."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "shape" {
  type        = string
  description = "Exadata shape available in the region, for example Exadata.X9M. There is no default. This service is billed and has no Always Free shape."

  validation {
    condition     = length(var.shape) > 0
    error_message = "shape must be set."
  }
}

variable "compute_count" {
  type        = number
  description = "Number of compute servers. Use the minimum the chosen shape allows."

  validation {
    condition     = var.compute_count >= 2
    error_message = "compute_count must be at least 2."
  }
}

variable "storage_count" {
  type        = number
  description = "Number of storage servers. Use the minimum the chosen shape allows."

  validation {
    condition     = var.storage_count >= 3
    error_message = "storage_count must be at least 3."
  }
}

variable "customer_contact_emails" {
  type        = list(string)
  description = "Email addresses Oracle uses for infrastructure maintenance notices."
  default     = []
}

variable "vm_cluster" {
  type = object({
    display_name           = string
    hostname               = string
    cpu_core_count         = number
    gi_version             = string
    subnet_id              = string
    backup_subnet_id       = string
    ssh_public_keys        = list(string)
    license_model          = optional(string, "LICENSE_INCLUDED")
    nsg_ids                = optional(set(string), [])
    backup_network_nsg_ids = optional(set(string), [])
  })
  description = "Optional VM cluster on this infrastructure. Null creates the infrastructure only. Database homes and databases are separate resources."
  default     = null
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
  description = "Defined tags applied to the infrastructure and VM cluster."
  default     = {}
}

check "vm_cluster_license" {
  assert {
    condition     = var.vm_cluster == null ? true : contains(["LICENSE_INCLUDED", "BRING_YOUR_OWN_LICENSE"], var.vm_cluster.license_model)
    error_message = "vm_cluster.license_model must be LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE."
  }
}
