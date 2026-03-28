variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where VPN resources will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "cpes" {
  type = map(object({
    display_name        = string
    ip_address          = string
    cpe_device_shape_id = optional(string, null)
    is_private          = optional(bool, false)
    freeform_tags       = optional(map(string), {})
    defined_tags        = optional(map(string), {})
  }))
  description = "Map of Customer-Premises Equipment (CPE) objects representing on-premises VPN devices."
  default     = {}

  validation {
    condition = alltrue([
      for cpe in var.cpes : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", cpe.ip_address))
    ])
    error_message = "Each CPE ip_address must be a valid IPv4 address."
  }
}

variable "ipsec_connections" {
  type = map(object({
    display_name  = string
    drg_id        = string
    static_routes = list(string)

    # Reference to a CPE — either a key in cpes variable or a direct OCID
    cpe_key = optional(string, null)
    cpe_id  = optional(string, null)

    cpe_local_identifier      = optional(string, null)
    cpe_local_identifier_type = optional(string, null)

    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of IPSec connections. Each connection creates 2 redundant tunnels. Always Free: 50 connections per tenancy. Use cpe_key to reference a CPE in the cpes variable, or cpe_id for an external CPE OCID."
  default     = {}

  validation {
    condition = alltrue([
      for conn in var.ipsec_connections : conn.cpe_key != null || conn.cpe_id != null
    ])
    error_message = "Each IPSec connection must have either cpe_key (referencing a key in cpes) or cpe_id (external CPE OCID)."
  }

  validation {
    condition = alltrue([
      for conn in var.ipsec_connections : length(conn.static_routes) >= 1 && length(conn.static_routes) <= 10
    ])
    error_message = "static_routes must contain 1-10 CIDR blocks."
  }

  validation {
    condition = alltrue([
      for conn in var.ipsec_connections : alltrue([
        for route in conn.static_routes : can(cidrhost(route, 0))
      ])
    ])
    error_message = "All static_routes must be valid CIDR blocks (e.g., 10.0.0.0/16)."
  }

  validation {
    condition = alltrue([
      for conn in var.ipsec_connections : conn.cpe_local_identifier_type == null || contains(["IP_ADDRESS", "HOSTNAME"], conn.cpe_local_identifier_type)
    ])
    error_message = "cpe_local_identifier_type must be 'IP_ADDRESS' or 'HOSTNAME' when specified."
  }
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
  type        = map(string)
  description = "Defined tags to apply to all resources"
  default     = {}
}
