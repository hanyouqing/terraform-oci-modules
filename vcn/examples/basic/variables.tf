variable "compartment_id" {
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
