# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------

variable "compartment_id" {
  description = "The OCID of the compartment to create the Network Load Balancer in."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.", var.compartment_id))
    error_message = "The compartment_id must be a valid OCI compartment OCID."
  }
}

variable "subnet_id" {
  description = "The OCID of the subnet to place the Network Load Balancer in."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.", var.subnet_id))
    error_message = "The subnet_id must be a valid OCI subnet OCID."
  }
}

# -----------------------------------------------------------------------------
# Network Load Balancer Configuration
# -----------------------------------------------------------------------------

variable "display_name" {
  description = "A user-friendly display name for the Network Load Balancer."
  type        = string
  default     = "network-load-balancer"
}

variable "is_private" {
  description = "Whether the NLB has a public or private IP address. Set to true for internal NLB."
  type        = bool
  default     = true
}

variable "is_preserve_source_destination" {
  description = "If true, preserves source and destination IP headers. Required for transparent routing."
  type        = bool
  default     = false
}

variable "is_symmetric_hash_enabled" {
  description = "If true, ensures that flows in both directions use the same backend server."
  type        = bool
  default     = false
}

variable "nsg_ids" {
  description = "List of Network Security Group OCIDs to associate with the NLB."
  type        = list(string)
  default     = []
}

variable "reserved_ips" {
  description = "List of reserved public IP OCIDs to assign to the NLB."
  type = list(object({
    id = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Backend Sets
# -----------------------------------------------------------------------------

variable "backend_sets" {
  description = "Map of backend set configurations. Policy options: FIVE_TUPLE, THREE_TUPLE, TWO_TUPLE."
  type = map(object({
    policy                    = string
    is_fail_open              = optional(bool, false)
    is_instant_failover       = optional(bool, false)
    is_preserve_source        = optional(bool, false)
    ip_version                = optional(string, "IPV4")
    are_operationally_grouped = optional(bool, false)
    health_checker = object({
      protocol            = string
      port                = optional(number, 0)
      interval_in_millis  = optional(number, 10000)
      timeout_in_millis   = optional(number, 3000)
      retries             = optional(number, 3)
      url_path            = optional(string, "/")
      return_code         = optional(number, 200)
      request_data        = optional(string)
      response_data       = optional(string)
      response_body_regex = optional(string)
    })
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.backend_sets : contains(["FIVE_TUPLE", "THREE_TUPLE", "TWO_TUPLE"], v.policy)
    ])
    error_message = "Backend set policy must be one of: FIVE_TUPLE, THREE_TUPLE, TWO_TUPLE."
  }

  validation {
    condition = alltrue([
      for k, v in var.backend_sets : contains(["TCP", "UDP", "HTTP", "HTTPS", "DNS"], v.health_checker.protocol)
    ])
    error_message = "Health checker protocol must be one of: TCP, UDP, HTTP, HTTPS, DNS."
  }
}

# -----------------------------------------------------------------------------
# Backends
# -----------------------------------------------------------------------------

variable "backends" {
  description = "Map of backend server configurations."
  type = map(object({
    backend_set_name = string
    ip_address       = optional(string)
    target_id        = optional(string)
    port             = number
    is_backup        = optional(bool, false)
    is_drain         = optional(bool, false)
    is_offline       = optional(bool, false)
    weight           = optional(number, 1)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.backends : v.port >= 1 && v.port <= 65535
    ])
    error_message = "Backend port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for k, v in var.backends : v.weight >= 1 && v.weight <= 100
    ])
    error_message = "Backend weight must be between 1 and 100."
  }
}

# -----------------------------------------------------------------------------
# Listeners
# -----------------------------------------------------------------------------

variable "listeners" {
  description = "Map of listener configurations. Protocol options: TCP, UDP, TCP_AND_UDP."
  type = map(object({
    default_backend_set_name = string
    port                     = number
    protocol                 = string
    ip_version               = optional(string, "IPV4")
    is_ppv2enabled           = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.listeners : contains(["TCP", "UDP", "TCP_AND_UDP"], v.protocol)
    ])
    error_message = "Listener protocol must be one of: TCP, UDP, TCP_AND_UDP."
  }

  validation {
    condition = alltrue([
      for k, v in var.listeners : v.port >= 1 && v.port <= 65535
    ])
    error_message = "Listener port must be between 1 and 65535."
  }
}

# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name (e.g., development, staging, production)."
  type        = string
  default     = "development"
}

variable "freeform_tags" {
  description = "Free-form tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags to apply to all resources."
  type        = map(string)
  default     = {}
}
