variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "target_subnet_id" {
  type        = string
  description = "OCID of the target subnet"
}

variable "bastion_client_cidr_block_allow_list" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to the bastion"
  default     = []
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the bastion session"
}
