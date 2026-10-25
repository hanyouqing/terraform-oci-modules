variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the cluster."
}

variable "vcn_id" {
  type        = string
  description = "VCN OCID for the cluster."
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the cluster."
}

variable "security_master_user_name" {
  type        = string
  description = "OpenSearch master user name."
  default     = "osadmin"
}

variable "security_master_user_password_hash" {
  type        = string
  description = "OpenSearch password hash of the master user."
  sensitive   = true
}
