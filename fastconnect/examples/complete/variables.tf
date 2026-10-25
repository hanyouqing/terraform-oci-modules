
variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the virtual circuit."
}

variable "display_name" {
  type        = string
  description = "Display name of the virtual circuit."
  default     = "fastconnect-complete"
}

variable "bandwidth_shape_name" {
  type        = string
  description = "Provider bandwidth shape."
}

variable "customer_bgp_asn" {
  type        = number
  description = "Customer BGP ASN."
}

variable "gateway_id" {
  type        = string
  description = "DRG OCID that terminates the private circuit."
}

variable "provider_service_id" {
  type        = string
  description = "FastConnect provider service OCID."
}

variable "provider_service_key_name" {
  type        = string
  description = "Provider service key. Null until the provider issues one."
  default     = null
}

variable "cross_connect_mappings" {
  type = list(object({
    cross_connect_or_cross_connect_group_id = optional(string)
    customer_bgp_peering_ip                 = optional(string)
    oracle_bgp_peering_ip                   = optional(string)
    vlan                                    = optional(number)
  }))
  description = "BGP peering mappings supplied by the provider."
  default     = []
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "fastconnect"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
