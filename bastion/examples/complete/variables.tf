variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "target_subnet_id" {
  type        = string
  description = "OCID of the target subnet"
}

variable "bastion_type" {
  type        = string
  description = "Bastion type"
  default     = "STANDARD"
}

variable "name" {
  type        = string
  description = "Bastion name"
  default     = "production-bastion"
}

variable "client_cidr_block_allow_list" {
  type        = list(string)
  description = "Client CIDR block allow list"
  default     = ["0.0.0.0/0"]
}

variable "max_session_ttl_in_seconds" {
  type        = number
  description = "Max session TTL in seconds"
  default     = 10800
}

variable "sessions" {
  type = map(object({
    display_name                              = string
    public_key_content                        = string
    session_type                              = string
    target_resource_id                        = string
    target_resource_operating_system_user_name = string
    target_resource_port                      = number
    target_resource_private_ip_address        = string
    session_ttl_in_seconds                    = number
  }))
  description = "Bastion sessions"
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
