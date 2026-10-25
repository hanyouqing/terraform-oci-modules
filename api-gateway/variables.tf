variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the API Gateway."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the gateway."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "endpoint_type" {
  type        = string
  description = "PRIVATE keeps the gateway on a private IP. PUBLIC assigns a public IP and needs allow_public_endpoint=true."
  default     = "PRIVATE"

  validation {
    condition     = contains(["PRIVATE", "PUBLIC"], var.endpoint_type)
    error_message = "endpoint_type must be PRIVATE or PUBLIC."
  }
}

variable "allow_public_endpoint" {
  type        = bool
  description = "Explicit approval for a PUBLIC gateway endpoint."
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the gateway."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "certificate_id" {
  type        = string
  description = "Optional Certificates service certificate OCID for TLS on the gateway."
  default     = null
}

variable "nsg_ids" {
  type        = list(string)
  description = "NSG OCIDs for the gateway."
  default     = []
}

variable "deployments" {
  type = map(object({
    path_prefix = string
    routes = list(object({
      path                  = string
      methods               = list(string)
      backend_type          = string
      backend_url           = optional(string)
      stock_response_body   = optional(string)
      stock_response_status = optional(number)
    }))
  }))
  description = "Optional deployments keyed by display name. Use STOCK_RESPONSE_BACKEND for a lab without a real backend URL."
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
  description = "Defined tags applied to the gateway and deployments."
  default     = {}
}
