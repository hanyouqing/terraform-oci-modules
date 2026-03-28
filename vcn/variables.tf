variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the VCN will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "vcn_display_name" {
  type        = string
  description = "Display name for the VCN"
  default     = "vcn"
}

variable "vcn_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for the VCN"
  default     = ["10.0.0.0/16"]

  validation {
    condition     = alltrue([for c in var.vcn_cidr_blocks : can(cidrnetmask(c))])
    error_message = "All elements in vcn_cidr_blocks must be valid IPv4 CIDR notation."
  }
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN"
  default     = null

  validation {
    condition     = var.vcn_dns_label == null ? true : can(regex("^[a-zA-Z][a-zA-Z0-9]{0,14}$", var.vcn_dns_label))
    error_message = "VCN DNS label must begin with a letter, be alphanumeric, and max 15 characters."
  }
}

variable "enable_ipv6" {
  type        = bool
  description = "Enable IPv6 for the VCN"
  default     = false
}

variable "create_internet_gateway" {
  type        = bool
  description = "Whether to create an Internet Gateway"
  default     = true
}

variable "internet_gateway_display_name" {
  type        = string
  description = "Display name for the Internet Gateway"
  default     = "internet-gateway"
}

variable "internet_gateway_enabled" {
  type        = bool
  description = "Whether the Internet Gateway is enabled"
  default     = true
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT Gateway"
  default     = false
}

variable "nat_gateway_display_name" {
  type        = string
  description = "Display name for the NAT Gateway"
  default     = "nat-gateway"
}

variable "nat_gateway_block_traffic" {
  type        = bool
  description = "Whether to block traffic on the NAT Gateway"
  default     = false
}

variable "create_service_gateway" {
  type        = bool
  description = "Whether to create a Service Gateway"
  default     = false
}

variable "service_gateway_display_name" {
  type        = string
  description = "Display name for the Service Gateway"
  default     = "service-gateway"
}

variable "service_gateway_services" {
  type = list(object({
    service_id   = string
    service_name = string
    cidr_block   = string
  }))
  description = "List of services for the Service Gateway"
  default     = []
}

variable "public_subnets" {
  type = map(object({
    cidr_block          = string
    display_name        = string
    dns_label           = optional(string, "")
    availability_domain = string
    security_list_ids   = optional(list(string), null)
  }))
  description = "Map of public subnets to create"
  default     = {}
}

variable "private_subnets" {
  type = map(object({
    cidr_block          = string
    display_name        = string
    dns_label           = optional(string, "")
    availability_domain = string
    security_list_ids   = optional(list(string), null)
  }))
  description = "Map of private subnets to create"
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
  type        = map(string)
  description = "Defined tags to apply to all resources (core networking resources expect map(string))"
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    display_name  = string
    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of Network Security Groups to create"
  default     = {}
}

variable "nsg_ingress_rules" {
  type = map(object({
    nsg_key      = string
    protocol     = string
    description  = optional(string, "")
    source       = string
    source_type  = string
    is_stateless = optional(bool, false)
    tcp_options = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    udp_options = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Map of NSG ingress rules to create"
  default     = {}
}

variable "nsg_egress_rules" {
  type = map(object({
    nsg_key          = string
    protocol         = string
    description      = optional(string, "")
    destination      = string
    destination_type = string
    is_stateless     = optional(bool, false)
    tcp_options = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    udp_options = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Map of NSG egress rules to create"
  default     = {}
}

variable "create_drg" {
  type        = bool
  description = "Whether to create a Dynamic Routing Gateway"
  default     = false
}

variable "drg_display_name" {
  type        = string
  description = "Display name for the DRG"
  default     = "drg"
}

variable "attach_drg_to_vcn" {
  type        = bool
  description = "Whether to attach DRG to VCN"
  default     = false

  validation {
    condition     = var.create_drg || !var.attach_drg_to_vcn
    error_message = "attach_drg_to_vcn can only be true when create_drg is true"
  }
}

variable "drg_route_tables" {
  type = map(object({
    display_name = string
  }))
  description = "Map of DRG route tables to create"
  default     = {}

  validation {
    condition     = var.create_drg || length(var.drg_route_tables) == 0
    error_message = "drg_route_tables can only be used when create_drg is true"
  }
}

variable "drg_route_distributions" {
  type = map(object({
    display_name      = string
    distribution_type = string
  }))
  description = "Map of DRG route distributions to create"
  default     = {}

  validation {
    condition     = var.create_drg || length(var.drg_route_distributions) == 0
    error_message = "drg_route_distributions can only be used when create_drg is true"
  }

  validation {
    condition = alltrue([
      for dist in var.drg_route_distributions : contains(["IMPORT", "EXPORT"], dist.distribution_type)
    ])
    error_message = "distribution_type must be either 'IMPORT' or 'EXPORT'"
  }
}

variable "local_peering_gateways" {
  type = map(object({
    display_name   = string
    route_table_id = optional(string, null)
    peer_id        = optional(string, null)
  }))
  description = "Map of Local Peering Gateways to create"
  default     = {}
}

variable "public_subnet_ingress_rules" {
  type = list(object({
    protocol    = string
    source      = string
    source_type = optional(string, "CIDR_BLOCK")
    description = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Ingress rules for default public subnet security lists. Default is empty (locked down). User must provide rules to allow traffic."
  default     = []
}

variable "public_subnet_egress_rules" {
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = optional(string, "CIDR_BLOCK")
    description      = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Egress rules for default public subnet security lists. Set to null to use default (allow all outbound)"
  default     = null
}

variable "private_subnet_ingress_rules" {
  type = list(object({
    protocol    = string
    source      = optional(string, null)
    source_type = optional(string, "CIDR_BLOCK")
    description = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Ingress rules for default private subnet security lists. source=null uses first VCN CIDR. Default is empty (locked down). User must provide rules to allow traffic."
  default     = []
}

variable "private_subnet_egress_rules" {
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = optional(string, "CIDR_BLOCK")
    description      = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Egress rules for default private subnet security lists. Set to null to use default (allow all outbound)"
  default     = null
}

variable "vcn_flow_log_enabled" {
  type        = bool
  description = "Whether the VCN flow log is enabled (when enable_vcn_flow_logs is true)"
  default     = true
}

variable "enable_vcn_flow_logs" {
  type        = bool
  description = "Whether to enable VCN Flow Logs"
  default     = false
}

variable "vcn_flow_log_retention_duration" {
  type        = number
  description = "Retention duration in days for VCN Flow Logs"
  default     = 30

  validation {
    condition     = var.vcn_flow_log_retention_duration >= 1 && var.vcn_flow_log_retention_duration <= 365
    error_message = "vcn_flow_log_retention_duration must be between 1 and 365 days"
  }
}
