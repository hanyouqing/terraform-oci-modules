variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the load balancer"
}
