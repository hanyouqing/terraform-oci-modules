variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "region" {
  type        = string
  description = "OCI region (used in bucket URI outputs)"
}

variable "bucket_name" {
  type        = string
  description = "Name of the state bucket (must be unique in the namespace)"
  default     = "terraform-oci-modules-tfstate"
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
