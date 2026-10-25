variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "ssh_allow_cidrs" {
  type        = list(string)
  description = "Optional CIDRs allowed for SSH (empty = no SSH ingress)"
  default     = []
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
