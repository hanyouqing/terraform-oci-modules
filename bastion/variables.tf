variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the bastion will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "target_subnet_id" {
  type        = string
  description = "OCID of the target subnet for the bastion"
}

variable "bastion_type" {
  type        = string
  description = "Type of bastion: STANDARD or SESSION"
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "SESSION"], var.bastion_type)
    error_message = "bastion_type must be STANDARD or SESSION"
  }
}

variable "name" {
  type        = string
  description = "Name of the bastion"
  default     = "bastion"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,255}$", var.name))
    error_message = "Bastion name must be alphanumeric with underscores or dashes, max 255 characters."
  }
}

variable "client_cidr_block_allow_list" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to the bastion. Recommended to restrict to your own public IP (e.g., ['1.2.3.4/32'])."
  default     = []

  validation {
    condition     = alltrue([for c in var.client_cidr_block_allow_list : can(cidrnetmask(c))])
    error_message = "All elements in client_cidr_block_allow_list must be valid IPv4 CIDR notation."
  }
}

variable "max_session_ttl_in_seconds" {
  type        = number
  description = "Maximum session TTL in seconds"
  default     = 10800

  validation {
    condition     = var.max_session_ttl_in_seconds >= 1800 && var.max_session_ttl_in_seconds <= 10800
    error_message = "max_session_ttl_in_seconds must be between 1800 (30 minutes) and 10800 (3 hours)"
  }
}

variable "sessions" {
  type = map(object({
    display_name                               = string
    public_key_content                         = string
    session_type                               = string
    target_resource_id                         = optional(string, null)
    target_resource_operating_system_user_name = optional(string, null)
    target_resource_port                       = optional(number, 22)
    target_resource_private_ip_address         = optional(string, null)
    session_ttl_in_seconds                     = optional(number, 3600)
  }))
  description = "Map of bastion sessions to create"
  default     = {}

  validation {
    condition = alltrue([
      for session in var.sessions : contains(["SSH", "PORT_FORWARDING"], session.session_type)
    ])
    error_message = "session_type must be SSH (Managed SSH) or PORT_FORWARDING (SSH Tunneling)."
  }

  validation {
    condition = alltrue([
      for session in var.sessions : session.target_resource_port > 0 && session.target_resource_port <= 65535
    ])
    error_message = "target_resource_port must be between 1 and 65535."
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
  description = "Defined tags to apply to all resources (OCI provider expects map(string) for this resource)"
  default     = {}
}
