variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID."
}

variable "display_name" {
  type        = string
  description = "Firewall display name."
  default     = "network-firewall-demo"
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the firewall."
}

variable "availability_domain" {
  type        = string
  description = "Availability Domain. Null lets the service choose when supported."
  default     = null
}

variable "nsg_ids" {
  type        = list(string)
  description = "NSG OCIDs."
  default     = []
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
