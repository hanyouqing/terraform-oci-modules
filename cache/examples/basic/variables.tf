variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the OCI Cache cluster."
}

variable "display_name" {
  type        = string
  description = "Display name of the cluster."
  default     = "cache-basic"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the cluster endpoint."
}

variable "software_version" {
  type        = string
  description = "OCI Cache engine version. VALKEY_8_1 is the version Oracle recommends for new clusters."
  default     = "VALKEY_8_1"
}

variable "node_count" {
  type        = number
  description = "Node count. 1 has no replica."
  default     = 1
}

variable "node_memory_in_gbs" {
  type        = number
  description = "Memory in gigabytes for each node."
  default     = 2
}
