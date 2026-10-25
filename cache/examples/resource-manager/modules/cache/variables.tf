variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the OCI Cache cluster."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the OCI Cache cluster."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "subnet_id" {
  type        = string
  description = "OCID of the private subnet for the cluster endpoint."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "software_version" {
  type        = string
  description = "OCI Cache engine version. Oracle recommends VALKEY_8_1 for new clusters. Confirm the value in the target region."

  validation {
    condition     = contains(["VALKEY_8_1", "VALKEY_7_2", "REDIS_7_0", "V7_0_5"], var.software_version)
    error_message = "software_version must be VALKEY_8_1, VALKEY_7_2, REDIS_7_0, or V7_0_5."
  }
}

variable "cluster_mode" {
  type        = string
  description = "NONSHARDED keeps one primary and optional replicas. SHARDED splits data across an odd number of shards."
  default     = "NONSHARDED"

  validation {
    condition     = contains(["NONSHARDED", "SHARDED"], var.cluster_mode)
    error_message = "cluster_mode must be NONSHARDED or SHARDED."
  }
}

variable "node_count" {
  type        = number
  description = "Total nodes for NONSHARDED, or nodes per shard for SHARDED. Use 3 for a non-sharded primary plus two replicas."

  validation {
    condition     = var.node_count == floor(var.node_count) && var.node_count >= 1 && var.node_count <= 5
    error_message = "node_count must be an integer from 1 to 5."
  }
}

variable "node_memory_in_gbs" {
  type        = number
  description = "Memory in gigabytes for each node. OCI Cache allows 2 to 500. A secondary cluster needs at least 8."

  validation {
    condition     = var.node_memory_in_gbs >= 2 && var.node_memory_in_gbs <= 500
    error_message = "node_memory_in_gbs must be from 2 to 500."
  }
}

variable "shard_count" {
  type        = number
  description = "Odd shard count from 3 to 99. Set only when cluster_mode is SHARDED."
  default     = null

  validation {
    condition = var.shard_count == null ? true : (
      var.shard_count == floor(var.shard_count) &&
      var.shard_count >= 3 &&
      var.shard_count <= 99 &&
      var.shard_count % 2 == 1
    )
    error_message = "shard_count must be an odd integer from 3 to 99."
  }
}

variable "nsg_ids" {
  type        = set(string)
  description = "NSG OCIDs for the cluster. Allow TCP 6379 only from the application, and require TLS."
  default     = []

  validation {
    condition = alltrue([
      for id in var.nsg_ids : can(regex("^ocid1\\.networksecuritygroup\\.oc1\\.", id))
    ])
    error_message = "nsg_ids must be network security group OCIDs."
  }
}

variable "oci_cache_config_set_id" {
  type        = string
  description = "OCID of a custom OCI Cache config set. Null uses the service default for the engine version."
  default     = null

  validation {
    condition     = var.oci_cache_config_set_id == null ? true : can(regex("^ocid1\\.ocicacheconfigset\\.oc1\\.", var.oci_cache_config_set_id))
    error_message = "oci_cache_config_set_id must be an OCI Cache config set OCID."
  }
}

variable "primary_cluster_id" {
  type        = string
  description = "OCID of the primary cluster when this cluster is a cross-region secondary. Null creates a standalone cluster."
  default     = null

  validation {
    condition     = var.primary_cluster_id == null ? true : can(regex("^ocid1\\.rediscluster\\.oc1\\.", var.primary_cluster_id))
    error_message = "primary_cluster_id must be an OCI Cache cluster OCID."
  }
}

variable "users" {
  type = map(object({
    description = string
    acl_string  = string
    status      = optional(string, "ON")
  }))
  description = "IAM OCI Cache users to create and attach. Keys are user names. Password hashes are not accepted."
  default     = {}

  validation {
    condition = alltrue([
      for name, user in var.users :
      can(regex("^[A-Za-z0-9._-]{1,40}$", name)) &&
      length(user.description) > 0 &&
      length(user.acl_string) > 0 &&
      !strcontains(user.acl_string, ">") &&
      !strcontains(user.acl_string, "#") &&
      contains(["ON", "OFF"], user.status)
    ])
    error_message = "Each user needs a name of 1 to 40 letters, digits, dots, underscores, or hyphens, a description, an ACL without a password, and status ON or OFF."
  }
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to the cluster and users."
  default     = {}
}

check "shard_count_matches_mode" {
  assert {
    condition = (
      var.cluster_mode == "SHARDED" && var.shard_count != null ? var.node_count * var.shard_count <= 100 : false
      ) || (
      var.cluster_mode == "NONSHARDED" && var.shard_count == null
    )
    error_message = "SHARDED clusters need shard_count and at most 100 nodes. NONSHARDED clusters leave shard_count unset."
  }
}

check "secondary_cluster_constraints" {
  assert {
    condition = var.primary_cluster_id == null ? true : (
      var.cluster_mode == "NONSHARDED" &&
      var.node_memory_in_gbs >= 8 &&
      var.oci_cache_config_set_id != null
    )
    error_message = "A secondary cluster is NONSHARDED, uses at least 8 GB per node, and needs oci_cache_config_set_id."
  }
}
