variable "compartment_ocid" {
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

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
