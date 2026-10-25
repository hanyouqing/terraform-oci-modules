variable "compartment_id" {
  type        = string
  description = "Compartment OCID."
}

variable "display_name" {
  type        = string
  description = "Application display name."
  default     = "functions-demo"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet OCIDs for the application."
}

variable "shape" {
  type        = string
  description = "GENERIC_X86 or GENERIC_ARM."
  default     = "GENERIC_X86"
}

variable "functions" {
  type = map(object({
    image              = string
    memory_in_mbs      = number
    timeout_in_seconds = optional(number, 30)
    image_digest       = optional(string)
    config             = optional(map(string), {})
  }))
  description = "Optional functions. Empty creates only the application."
  default     = {}
}
