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

variable "software_version" {
  type        = string
  description = "OpenSearch software version."
  default     = "2.15.0"
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

variable "remote_ca_bundle_id" {
  type        = string
  description = "CA bundle OCID that validates the remote cluster certificate."
}

variable "remote_endpoint" {
  type        = string
  description = "HTTPS URL of the remote OpenSearch or Elasticsearch source."
}

variable "remote_endpoint_resolution_ip" {
  type        = string
  description = "Optional IP used to resolve the remote hostname. TLS still checks the hostname."
  default     = null
}
