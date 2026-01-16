variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the VCN will be created"
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
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN"
  default     = null
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
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    display_name   = string
    freeform_tags  = optional(map(string), {})
    defined_tags   = optional(map(map(string)), {})
  }))
  description = "Map of Network Security Groups to create"
  default     = {}
}

variable "nsg_ingress_rules" {
  type = map(object({
    nsg_key           = string
    protocol          = string
    description       = optional(string, "")
    source            = string
    source_type       = string
    is_stateless      = optional(bool, false)
    tcp_options       = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    udp_options       = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    icmp_options      = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  description = "Map of NSG ingress rules to create"
  default     = {}
}

variable "nsg_egress_rules" {
  type = map(object({
    nsg_key           = string
    protocol          = string
    description       = optional(string, "")
    destination       = string
    destination_type  = string
    is_stateless      = optional(bool, false)
    tcp_options       = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    udp_options       = optional(object({
      destination_port_min = number
      destination_port_max = number
      source_port_min      = optional(number, null)
      source_port_max      = optional(number, null)
    }), null)
    icmp_options      = optional(object({
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
}

variable "drg_route_tables" {
  type = map(object({
    display_name = string
  }))
  description = "Map of DRG route tables to create"
  default     = {}
}

variable "drg_route_distributions" {
  type = map(object({
    display_name     = string
    distribution_type = string
  }))
  description = "Map of DRG route distributions to create"
  default     = {}
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

variable "enable_vcn_flow_logs" {
  type        = bool
  description = "Whether to enable VCN Flow Logs"
  default     = false
}

variable "vcn_flow_log_retention_duration" {
  type        = number
  description = "Retention duration in days for VCN Flow Logs"
  default     = 30
}
