variable "compartment_id" {
  description = "The OCID of the compartment to create the Network Load Balancer in."
  type        = string
}

variable "subnet_id" {
  description = "The OCID of the subnet to place the Network Load Balancer in."
  type        = string
}

variable "display_name" {
  description = "A user-friendly display name for the Network Load Balancer."
  type        = string
  default     = "production-nlb"
}

variable "is_private" {
  description = "Whether the NLB has a public or private IP address."
  type        = bool
  default     = false
}

variable "is_preserve_source_destination" {
  description = "If true, preserves source and destination IP headers."
  type        = bool
  default     = true
}

variable "is_symmetric_hash_enabled" {
  description = "If true, ensures bidirectional flows use the same backend."
  type        = bool
  default     = true
}

variable "nsg_ids" {
  description = "List of Network Security Group OCIDs."
  type        = list(string)
  default     = []
}

variable "reserved_ips" {
  description = "List of reserved public IP OCIDs."
  type = list(object({
    id = string
  }))
  default = []
}

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "production"
}

variable "freeform_tags" {
  description = "Free-form tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags to apply to all resources."
  type        = map(string)
  default     = {}
}
