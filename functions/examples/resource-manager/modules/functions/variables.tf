variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the Functions application."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the Functions application."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet OCIDs for the application. Prefer private subnets."

  validation {
    condition = length(var.subnet_ids) > 0 && alltrue([
      for id in var.subnet_ids : can(regex("^ocid1\\.subnet\\.oc1\\.", id))
    ])
    error_message = "subnet_ids must contain at least one subnet OCID."
  }
}

variable "shape" {
  type        = string
  description = "GENERIC_X86 or GENERIC_ARM for function execution."
  default     = "GENERIC_X86"

  validation {
    condition     = contains(["GENERIC_X86", "GENERIC_ARM", "GENERIC_X86_ARM"], var.shape)
    error_message = "shape must be GENERIC_X86, GENERIC_ARM, or GENERIC_X86_ARM."
  }
}

variable "nsg_ids" {
  type        = list(string)
  description = "NSG OCIDs for the application."
  default     = []
}

variable "application_config" {
  type        = map(string)
  description = "Application-level configuration passed to functions as environment variables."
  default     = {}
}

variable "syslog_url" {
  type        = string
  description = "Optional syslog URL for function logs."
  default     = null
}

variable "functions" {
  type = map(object({
    image              = string
    memory_in_mbs      = number
    timeout_in_seconds = optional(number, 30)
    image_digest       = optional(string)
    config             = optional(map(string), {})
  }))
  description = "Functions keyed by display name. image is an OCIR image reference in the same region. Empty creates only the application."
  default     = {}

  validation {
    condition = alltrue([
      for name, fn in var.functions :
      length(name) > 0 &&
      length(fn.image) > 0 &&
      contains([128, 256, 512, 1024, 2048, 3072], fn.memory_in_mbs) &&
      fn.timeout_in_seconds >= 1 && fn.timeout_in_seconds <= 300
    ])
    error_message = "Each function needs a name, OCIR image, memory_in_mbs in {128,256,512,1024,2048,3072}, and timeout 1 to 300 seconds."
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
  description = "Defined tags applied to the application and functions."
  default     = {}
}
