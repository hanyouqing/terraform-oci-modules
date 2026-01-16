variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "display_name" {
  type        = string
  description = "Display name"
  default     = "production-lb"
}

variable "shape" {
  type        = string
  description = "Load balancer shape"
  default     = "flexible"
}

variable "is_private" {
  type        = bool
  description = "Is private load balancer"
  default     = false
}

variable "shape_details" {
  type = object({
    minimum_bandwidth_in_mbps = number
    maximum_bandwidth_in_mbps = number
  })
  description = "Shape details"
  default = {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "nsg_ids" {
  type        = list(string)
  description = "Network Security Group IDs"
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
  description = "Backend sets"
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
  description = "Backends"
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
  description = "Listeners"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags"
  default     = {}
}
