variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the Network Firewall and policy."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the Network Firewall."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID where the firewall attaches. Prefer a dedicated firewall subnet."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "availability_domain" {
  type        = string
  description = "Availability Domain for the firewall. Null lets the service choose when supported."
  default     = null
}

variable "nsg_ids" {
  type        = list(string)
  description = "NSG OCIDs attached to the firewall."
  default     = []
}

variable "ipv4address" {
  type        = string
  description = "Optional fixed IPv4 address in the subnet."
  default     = null
}

variable "shape" {
  type        = string
  description = "Firewall shape that sets throughput. Confirm the value in the target region."
  default     = null
}

variable "must_enable_private_nat" {
  type        = bool
  description = "When set, configures private NAT on the firewall. Null skips the block."
  default     = null
}

variable "policy_display_name" {
  type        = string
  description = "Display name for the firewall policy. Null derives from display_name."
  default     = null
}

variable "policy_description" {
  type        = string
  description = "Description for the firewall policy."
  default     = "Managed by terraform-oci-modules/network-firewall"
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
  description = "Defined tags applied to the firewall and policy."
  default     = {}
}
