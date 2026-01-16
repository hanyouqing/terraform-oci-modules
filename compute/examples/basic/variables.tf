variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet"
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public key"
}
