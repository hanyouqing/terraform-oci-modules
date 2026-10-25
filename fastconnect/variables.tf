variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the virtual circuit."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the virtual circuit."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "type" {
  type        = string
  description = "PRIVATE terminates on a DRG. PUBLIC advertises public prefixes."
  default     = "PRIVATE"

  validation {
    condition     = contains(["PRIVATE", "PUBLIC"], var.type)
    error_message = "type must be PRIVATE or PUBLIC."
  }
}

variable "bandwidth_shape_name" {
  type        = string
  description = "Provider bandwidth shape, for example 1 Gbps. Confirm the name with the FastConnect provider in the target region."

  validation {
    condition     = length(var.bandwidth_shape_name) > 0
    error_message = "bandwidth_shape_name must be set."
  }
}

variable "customer_bgp_asn" {
  type        = number
  description = "BGP ASN of the customer edge. Use a private ASN unless the provider requires a public one."

  validation {
    condition     = var.customer_bgp_asn > 0 && var.customer_bgp_asn <= 4294967295
    error_message = "customer_bgp_asn must be a BGP ASN."
  }
}

variable "gateway_id" {
  type        = string
  description = "OCID of the DRG that terminates a private virtual circuit."

  validation {
    condition     = can(regex("^ocid1\\.drg\\.oc1\\.", var.gateway_id))
    error_message = "gateway_id must be a DRG OCID."
  }
}

variable "provider_service_id" {
  type        = string
  description = "OCID of the FastConnect provider service. This is not created by the module."

  validation {
    condition     = can(regex("^ocid1\\.providerservice\\.oc1\\.", var.provider_service_id))
    error_message = "provider_service_id must be a provider service OCID."
  }
}

variable "provider_service_key_name" {
  type        = string
  description = "Provider service key issued for this circuit. Leave null until the provider has issued one."
  default     = null
}

variable "provider_remote_region" {
  type        = string
  description = "Remote OCI region for a remote-peering style provider circuit. Leave null for a partner or colocation circuit."
  default     = null
}

variable "is_bfd_enabled" {
  type        = bool
  description = "Enable BFD on the virtual circuit so a failed path is detected without waiting for BGP hold time."
  default     = true
}

variable "routing_policy" {
  type        = list(string)
  description = "Optional OCI routing policy names for a public virtual circuit."
  default     = null
}

variable "ip_mtu" {
  type        = string
  description = "IP MTU advertised on the circuit. Leave null to accept the provider default."
  default     = null
}

variable "cross_connect_mappings" {
  type = list(object({
    cross_connect_or_cross_connect_group_id = optional(string)
    customer_bgp_peering_ip                 = optional(string)
    oracle_bgp_peering_ip                   = optional(string)
    vlan                                    = optional(number)
  }))
  description = "BGP peering and cross-connect mappings. Leave empty until the provider has allocated the cross-connect. BGP MD5 keys are not accepted here because the provider stores them in state."
  default     = []
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to the virtual circuit."
  default     = {}
}
