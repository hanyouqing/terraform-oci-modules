
variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the virtual circuit."
}

variable "display_name" {
  type        = string
  description = "Display name of the virtual circuit."
  default     = "fastconnect-basic"
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

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
