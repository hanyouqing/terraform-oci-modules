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
  description = "OCID of the public subnet"
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public key(s), newline-separated"
}

variable "display_name" {
  type        = string
  description = "Instance display name prefix"
  default     = "edge-arm"
}

variable "hostname_label" {
  type        = string
  description = "Hostname label prefix"
  default     = "edgearm"
}

variable "user_data" {
  type        = string
  description = "Optional base64-encoded user_data from the caller"
  default     = null
}

variable "nsg_ids" {
  type        = list(string)
  description = "NSG OCIDs to attach"
  default     = []
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "development"
}
