variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the load balancer"
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
