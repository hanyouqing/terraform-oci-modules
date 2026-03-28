variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "drg_id" {
  type        = string
  description = "OCID of the Dynamic Routing Gateway"
}

variable "cpe_ip_address" {
  type        = string
  description = "Public IP address of the on-premises VPN device"
}
