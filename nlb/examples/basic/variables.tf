variable "compartment_id" {
  description = "The OCID of the compartment to create the Network Load Balancer in."
  type        = string
}

variable "subnet_id" {
  description = "The OCID of the subnet to place the Network Load Balancer in."
  type        = string
}

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "development"
}
