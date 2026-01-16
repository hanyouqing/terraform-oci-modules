variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "region" {
  type        = string
  description = "OCI region"
  default     = "us-ashburn-1"
}
