variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "vcn_display_name" {
  type        = string
  description = "Display name for the VCN"
  default     = "production-vcn"
}

variable "vcn_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for the VCN"
  default     = ["10.0.0.0/16"]
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN"
  default     = "prodvcn"
}

variable "enable_ipv6" {
  type        = bool
  description = "Enable IPv6"
  default     = false
}

variable "create_drg" {
  type        = bool
  description = "Create Dynamic Routing Gateway"
  default     = false
}

variable "drg_display_name" {
  type        = string
  description = "Display name for DRG"
  default     = "production-drg"
}

variable "attach_drg_to_vcn" {
  type        = bool
  description = "Attach DRG to VCN"
  default     = false
}

variable "enable_vcn_flow_logs" {
  type        = bool
  description = "Enable VCN Flow Logs"
  default     = true
}

variable "vcn_flow_log_retention_duration" {
  type        = number
  description = "Flow log retention in days"
  default     = 30
}

variable "service_gateway_services" {
  type = list(object({
    service_id   = string
    service_name = string
    cidr_block   = string
  }))
  description = "Service Gateway services"
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
  description = "Public subnets"
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
  description = "Private subnets"
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    display_name   = string
    freeform_tags  = optional(map(string), {})
    defined_tags   = optional(map(map(string)), {})
  }))
  description = "Network Security Groups"
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
  description = "NSG ingress rules"
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
  description = "NSG egress rules"
  default     = {}
}

variable "local_peering_gateways" {
  type = map(object({
    display_name   = string
    route_table_id = optional(string, null)
    peer_id        = optional(string, null)
  }))
  description = "Local Peering Gateways"
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
