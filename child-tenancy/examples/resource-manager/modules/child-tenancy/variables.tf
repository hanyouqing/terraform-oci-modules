variable "compartment_id" {
  type        = string
  description = "OCID of the parent tenancy. Organizations requires the parent tenancy OCID, not a child compartment."

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be the parent tenancy OCID."
  }
}

variable "tenancy_name" {
  type        = string
  description = "Cloud account name of the child tenancy."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,49}$", var.tenancy_name))
    error_message = "tenancy_name must start with a lowercase letter and contain only lowercase letters, digits, and hyphens."
  }
}

variable "home_region" {
  type        = string
  description = "Home region of the child tenancy. The parent tenancy must already be subscribed to this region."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.home_region))
    error_message = "home_region must look like an OCI region identifier, for example us-ashburn-1."
  }
}

variable "admin_email" {
  type        = string
  description = "Email address of the child tenancy administrator. OCI sends the activation message to this address."

  validation {
    condition     = can(regex("^[^[:space:]@]+@[^[:space:]@]+\\.[^[:space:]@]+$", var.admin_email))
    error_message = "admin_email must be an email address."
  }
}

variable "governance_status" {
  type        = string
  description = "Whether the parent governs the child tenancy. OPTED_IN lets the parent manage the child. OPTED_OUT creates the child without governance."
  default     = "OPTED_IN"

  validation {
    condition     = contains(["OPTED_IN", "OPTED_OUT"], var.governance_status)
    error_message = "governance_status must be OPTED_IN or OPTED_OUT."
  }
}

variable "policy_name" {
  type        = string
  description = "Name of the administrator policy created in the child tenancy. Letters and underscores only. Leave null to let Organizations choose the name."
  default     = null

  validation {
    condition     = var.policy_name == null ? true : can(regex("^[A-Za-z_]+$", var.policy_name))
    error_message = "policy_name must contain only letters and underscores."
  }
}

variable "features" {
  type        = list(string)
  description = "Organization links to create in addition to the CORE link, which Organizations always creates. Leave empty to add no extra links."
  default     = []

  validation {
    condition = alltrue([
      for feature in var.features : length(feature) > 0
    ])
    error_message = "features entries must be non-empty strings."
  }
}
