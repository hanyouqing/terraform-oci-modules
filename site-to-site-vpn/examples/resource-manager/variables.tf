variable "compartment_ocid" {
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

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
