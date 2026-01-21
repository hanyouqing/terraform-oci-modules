variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the bastion will be created"
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
}

variable "client_cidr_block_allow_list" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to the bastion"
  default     = ["0.0.0.0/0"]
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
    target_resource_id                         = string
    target_resource_operating_system_user_name = string
    target_resource_port                       = number
    target_resource_private_ip_address         = string
    session_ttl_in_seconds                     = number
  }))
  description = "Map of bastion sessions to create"
  default     = {}

  validation {
    condition = alltrue([
      for session in var.sessions : contains(["SSH", "PORT_FORWARDING"], session.session_type)
    ])
    error_message = "session_type must be SSH or PORT_FORWARDING"
  }

  validation {
    condition = alltrue([
      for session in var.sessions : session.target_resource_port > 0 && session.target_resource_port <= 65535
    ])
    error_message = "target_resource_port must be between 1 and 65535"
  }

  validation {
    condition = alltrue([
      for session in var.sessions : session.session_ttl_in_seconds > 0 && session.session_ttl_in_seconds <= var.max_session_ttl_in_seconds
    ])
    error_message = "session_ttl_in_seconds must be between 1 and max_session_ttl_in_seconds"
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
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
