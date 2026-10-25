variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the OCI Cache cluster and users."
}

variable "display_name" {
  type        = string
  description = "Display name of the cluster."
  default     = "cache-complete"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the cluster endpoint."
}

variable "software_version" {
  type        = string
  description = "OCI Cache engine version."
  default     = "VALKEY_8_1"
}

variable "cluster_mode" {
  type        = string
  description = "NONSHARDED or SHARDED."
  default     = "NONSHARDED"
}

variable "node_count" {
  type        = number
  description = "Total nodes, or nodes per shard when sharded. 3 is one primary and two replicas."
  default     = 3
}

variable "node_memory_in_gbs" {
  type        = number
  description = "Memory in gigabytes for each node."
  default     = 8
}

variable "shard_count" {
  type        = number
  description = "Odd shard count. Leave null for NONSHARDED."
  default     = null
}

variable "nsg_ids" {
  type        = set(string)
  description = "NSG OCIDs. Allow TCP 6379 only from the application."
  default     = []
}

variable "users" {
  type = map(object({
    description = string
    acl_string  = string
    status      = optional(string, "ON")
  }))
  description = "IAM cache users. The ACL does not contain a password."
  default = {
    app = {
      description = "Application cache user"
      acl_string  = "~app:* +@read +@write"
    }
  }
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "cache"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
