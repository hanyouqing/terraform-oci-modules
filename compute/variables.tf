variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the compute instance will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "instance_count" {
  type        = number
  description = "Number of compute instances to create"
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "instance_count must be greater than 0"
  }
}

variable "shape" {
  type        = string
  description = "Shape of the compute instance (e.g. VM.Standard.E2.1.Micro, VM.Standard.A1.Flex, VM.Standard.E4.Flex)"
  default     = "VM.Standard.E2.1.Micro"

  validation {
    condition     = can(regex("^VM\\..*", var.shape))
    error_message = "Shape must be a valid OCI VM shape starting with 'VM.'."
  }
}

variable "ocpus" {
  type        = number
  description = "Number of OCPUs for flexible shapes (e.g. VM.Standard.A1.Flex)"
  default     = 1

  validation {
    condition     = var.ocpus >= 1 && var.ocpus <= 114
    error_message = "ocpus must be between 1 and 114."
  }
}

variable "memory_in_gbs" {
  type        = number
  description = "Memory in GBs for flexible shapes (e.g. VM.Standard.A1.Flex)"
  default     = 6

  validation {
    condition     = var.memory_in_gbs >= 1 && var.memory_in_gbs <= 1760
    error_message = "memory_in_gbs must be between 1 and 1760."
  }
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet where the instance will be created"
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for the instance. If not specified, will be distributed across ADs"
  default     = null
}

variable "display_name" {
  type        = string
  description = "Display name for the compute instance(s)"
  default     = "compute-instance"
}

variable "image_id" {
  type        = string
  description = "OCID of the image to use. If not specified, will use the latest image for the specified OS"
  default     = null
}

variable "image_operating_system" {
  type        = string
  description = "Operating system for the image (e.g., Oracle Linux, Ubuntu)"
  default     = "Oracle Linux"
}

variable "image_operating_system_version" {
  type        = string
  description = "Operating system version for the image"
  default     = null
}

variable "image_sort_by" {
  type        = string
  description = "Sort order for image selection (TIMECREATED, DISPLAYNAME)"
  default     = "TIMECREATED"
}

variable "image_sort_order" {
  type        = string
  description = "Sort direction for image selection (ASC, DESC)"
  default     = "DESC"
}

variable "flexible_shapes" {
  type        = list(string)
  description = "List of shapes that require ocpus/memory_in_gbs (e.g. VM.Standard.A1.Flex, VM.Standard.E3.Flex)"
  default     = ["VM.Standard.A1.Flex", "VM.Standard.E3.Flex", "VM.Standard.E4.Flex"]
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP address"
  default     = true
}

variable "hostname_label" {
  type        = string
  description = "Hostname label for the instance"
  default     = null
}

variable "vnic_display_name" {
  type        = string
  description = "Display name for the VNIC"
  default     = null
}

variable "skip_source_dest_check" {
  type        = bool
  description = "Whether to skip source/destination check"
  default     = false
}

variable "nsg_ids" {
  type        = list(string)
  description = "List of Network Security Group OCIDs to attach"
  default     = []
}

variable "private_ip" {
  type        = string
  description = "Private IP address for the instance"
  default     = null
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public key(s) for the instance. Multiple keys should be newline separated."

  validation {
    condition     = length(var.ssh_public_keys) > 0
    error_message = "ssh_public_keys cannot be empty."
  }
}

variable "user_data" {
  type        = string
  description = "User data script to run on instance launch"
  default     = null
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable OCI monitoring agent"
  default     = true
}

variable "enable_management_agent" {
  type        = bool
  description = "Enable OCI management agent"
  default     = false
}

variable "enable_pv_encryption_in_transit" {
  type        = bool
  description = "Enable encryption in transit for paravirtualized boot volumes"
  default     = true
}

variable "create_boot_volume" {
  type        = bool
  description = "Whether to create a separate boot volume"
  default     = false
}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "Size of the boot volume in GBs"
  default     = 50

  validation {
    condition     = var.boot_volume_size_in_gbs >= 50
    error_message = "boot_volume_size_in_gbs must be at least 50 GB"
  }
}

variable "boot_volume_vpus_per_gb" {
  type        = string
  description = "VPUs per GB for the boot volume"
  default     = "10"
}

variable "block_volumes" {
  type = map(object({
    display_name         = string
    size_in_gbs          = number
    availability_domain  = optional(string, null)
    instance_index       = number
    device               = optional(string, null)
    vpus_per_gb          = optional(string, "10")
    is_auto_tune_enabled = optional(bool, false)
  }))
  description = "Map of block volumes to create and attach"
  default     = {}

  validation {
    condition = var.instance_count == 0 ? length(var.block_volumes) == 0 : alltrue([
      for v in var.block_volumes : v.instance_index >= 0 && v.instance_index < var.instance_count
    ])
    error_message = "instance_index must be between 0 and instance_count - 1. If instance_count is 0, block_volumes must be empty."
  }

  validation {
    condition = alltrue([
      for v in var.block_volumes : v.size_in_gbs >= 50
    ])
    error_message = "Each block volume size must be at least 50 GB"
  }
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources"
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all resources (oci_core_instance expects map(string))"
  default     = {}
}
