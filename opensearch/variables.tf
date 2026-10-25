variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the OpenSearch cluster."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the OpenSearch cluster."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "software_version" {
  type        = string
  description = "OpenSearch software version, for example 2.15.0."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.software_version))
    error_message = "software_version must look like 2.15.0."
  }
}

variable "vcn_id" {
  type        = string
  description = "OCID of the VCN for the cluster."

  validation {
    condition     = can(regex("^ocid1\\.vcn\\.oc1\\.", var.vcn_id))
    error_message = "vcn_id must be a VCN OCID."
  }
}

variable "vcn_compartment_id" {
  type        = string
  description = "Compartment OCID of the VCN. Leave null to use compartment_id."
  default     = null

  validation {
    condition     = var.vcn_compartment_id == null || can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.vcn_compartment_id))
    error_message = "vcn_compartment_id must be a compartment or tenancy OCID."
  }
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet for the cluster."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "subnet_compartment_id" {
  type        = string
  description = "Compartment OCID of the subnet. Leave null to use compartment_id."
  default     = null

  validation {
    condition     = var.subnet_compartment_id == null || can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.subnet_compartment_id))
    error_message = "subnet_compartment_id must be a compartment or tenancy OCID."
  }
}

variable "master_node_count" {
  type        = number
  description = "Number of cluster manager nodes."

  validation {
    condition     = var.master_node_count >= 1
    error_message = "master_node_count must be at least 1."
  }
}

variable "master_node_host_type" {
  type        = string
  description = "Host type of the cluster manager nodes."
  default     = "FLEX"
}

variable "master_node_host_ocpu_count" {
  type        = number
  description = "OCPU count of each cluster manager node."

  validation {
    condition     = var.master_node_host_ocpu_count >= 1
    error_message = "master_node_host_ocpu_count must be at least 1."
  }
}

variable "master_node_host_memory_gb" {
  type        = number
  description = "Memory in gigabytes of each cluster manager node."

  validation {
    condition     = var.master_node_host_memory_gb >= 1
    error_message = "master_node_host_memory_gb must be at least 1."
  }
}

variable "data_node_count" {
  type        = number
  description = "Number of data nodes."

  validation {
    condition     = var.data_node_count >= 1
    error_message = "data_node_count must be at least 1."
  }
}

variable "data_node_host_type" {
  type        = string
  description = "Host type of the data nodes."
  default     = "FLEX"
}

variable "data_node_host_ocpu_count" {
  type        = number
  description = "OCPU count of each data node."

  validation {
    condition     = var.data_node_host_ocpu_count >= 1
    error_message = "data_node_host_ocpu_count must be at least 1."
  }
}

variable "data_node_host_memory_gb" {
  type        = number
  description = "Memory in gigabytes of each data node."

  validation {
    condition     = var.data_node_host_memory_gb >= 1
    error_message = "data_node_host_memory_gb must be at least 1."
  }
}

variable "data_node_storage_gb" {
  type        = number
  description = "Data storage in gigabytes on each data node."

  validation {
    condition     = var.data_node_storage_gb >= 1
    error_message = "data_node_storage_gb must be at least 1."
  }
}

variable "opendashboard_node_count" {
  type        = number
  description = "Number of OpenSearch Dashboards nodes."

  validation {
    condition     = var.opendashboard_node_count >= 1
    error_message = "opendashboard_node_count must be at least 1."
  }
}

variable "opendashboard_node_host_ocpu_count" {
  type        = number
  description = "OCPU count of each OpenSearch Dashboards node."

  validation {
    condition     = var.opendashboard_node_host_ocpu_count >= 1
    error_message = "opendashboard_node_host_ocpu_count must be at least 1."
  }
}

variable "opendashboard_node_host_memory_gb" {
  type        = number
  description = "Memory in gigabytes of each OpenSearch Dashboards node."

  validation {
    condition     = var.opendashboard_node_host_memory_gb >= 1
    error_message = "opendashboard_node_host_memory_gb must be at least 1."
  }
}

variable "security_mode" {
  type        = string
  description = "Security mode of the cluster."
  default     = "ENFORCING"

  validation {
    condition     = contains(["ENFORCING", "PERMISSIVE"], var.security_mode)
    error_message = "security_mode must be ENFORCING or PERMISSIVE."
  }
}

variable "security_master_user_name" {
  type        = string
  description = "Master user name used when security_mode is ENFORCING."

  validation {
    condition     = length(var.security_master_user_name) > 0
    error_message = "security_master_user_name must be set."
  }
}

variable "security_master_user_password_hash" {
  type        = string
  description = "OpenSearch password hash of the master user. Pass a hash, not the plaintext password."
  sensitive   = true

  validation {
    condition     = length(var.security_master_user_password_hash) > 0
    error_message = "security_master_user_password_hash must be set."
  }
}

variable "remote_reindex_sources" {
  type = list(object({
    ca_bundle_id           = string
    endpoint               = string
    certificate_id         = optional(string)
    endpoint_resolution_ip = optional(string)
  }))
  description = "Remote clusters trusted for reindex. Provider 9.11.0 added remote_reindex_trust_config. Leave empty to disable remote reindex."
  default     = []

  validation {
    condition = alltrue([
      for source in var.remote_reindex_sources : startswith(source.endpoint, "https://")
    ])
    error_message = "Each remote reindex endpoint must be an https URL."
  }

  validation {
    condition = alltrue([
      for source in var.remote_reindex_sources : can(regex("^ocid1\\.cabundle\\.oc1\\.", source.ca_bundle_id))
    ])
    error_message = "Each remote reindex source needs a CA bundle OCID."
  }

  validation {
    condition = alltrue([
      for source in var.remote_reindex_sources :
      source.endpoint_resolution_ip == null || can(cidrhost("${source.endpoint_resolution_ip}/32", 0))
    ])
    error_message = "endpoint_resolution_ip must be an IPv4 address when set."
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
  description = "Defined tags applied to the cluster."
  default     = {}
}
