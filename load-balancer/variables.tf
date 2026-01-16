variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the load balancer will be created"
}

variable "display_name" {
  type        = string
  description = "Display name for the load balancer"
  default     = "load-balancer"
}

variable "shape" {
  type        = string
  description = "Shape of the load balancer. For Always Free, use 'flexible'"
  default     = "flexible"

  validation {
    condition     = contains(["flexible", "10Mbps", "100Mbps", "400Mbps", "8000Mbps"], var.shape)
    error_message = "shape must be one of: flexible, 10Mbps, 100Mbps, 400Mbps, 8000Mbps"
  }
}

variable "is_private" {
  type        = bool
  description = "Whether the load balancer is private"
  default     = false
}

variable "shape_details" {
  type = object({
    minimum_bandwidth_in_mbps = number
    maximum_bandwidth_in_mbps = number
  })
  description = "Shape details for flexible load balancer"
  default = {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet OCIDs for the load balancer"
}

variable "nsg_ids" {
  type        = list(string)
  description = "List of Network Security Group OCIDs"
  default     = []
}

variable "backend_sets" {
  type = map(object({
    policy = string
    health_checker = object({
      protocol            = string
      port                = number
      url_path            = string
      interval_ms         = number
      timeout_in_millis   = number
      retries             = number
      response_body_regex  = string
    })
    ssl_configuration = optional(object({
      certificate_ids                  = optional(list(string), [])
      certificate_name                 = optional(string, "")
      verify_depth                     = optional(number, 1)
      verify_peer_certificate         = optional(bool, false)
      protocols                        = optional(list(string), [])
      cipher_suite_name                = optional(string, "")
      server_order_preference          = optional(string, "")
      trusted_certificate_authority_ids = optional(list(string), [])
    }))
  }))
  description = "Map of backend sets to create"
  default     = {}
}

variable "backends" {
  type = map(object({
    backendset_name = string
    ip_address      = string
    port            = number
    backup          = bool
    drain           = bool
    offline         = bool
    weight          = number
  }))
  description = "Map of backends to create"
  default     = {}
}

variable "listeners" {
  type = map(object({
    default_backend_set_name = string
    port                     = number
    protocol                  = string
    ssl_configuration = optional(object({
      certificate_ids                  = optional(list(string), [])
      certificate_name                 = optional(string, "")
      verify_depth                     = optional(number, 1)
      verify_peer_certificate         = optional(bool, false)
      protocols                        = optional(list(string), [])
      cipher_suite_name                = optional(string, "")
      server_order_preference          = optional(string, "")
      trusted_certificate_authority_ids = optional(list(string), [])
    }))
    connection_configuration = object({
      idle_timeout_in_seconds = number
    })
  }))
  description = "Map of listeners to create"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
