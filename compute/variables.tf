variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the compute instance will be created"
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
    condition     = var.instance_count > 0 && var.instance_count <= 2
    error_message = "For Always Free, instance_count must be between 1 and 2 for VM.Standard.E2.1.Micro, or up to 4 OCPUs for VM.Standard.A1.Flex"
  }
}

variable "shape" {
  type        = string
  description = "Shape of the compute instance. Always Free shapes: VM.Standard.E2.1.Micro or VM.Standard.A1.Flex"
  default     = "VM.Standard.E2.1.Micro"

  validation {
    condition     = contains(["VM.Standard.E2.1.Micro", "VM.Standard.A1.Flex"], var.shape)
    error_message = "shape must be one of the Always Free shapes: VM.Standard.E2.1.Micro or VM.Standard.A1.Flex"
  }
}

variable "ocpus" {
  type        = number
  description = "Number of OCPUs for VM.Standard.A1.Flex shape (1-4 for Always Free)"
  default     = 1

  validation {
    condition     = var.ocpus >= 1 && var.ocpus <= 4
    error_message = "ocpus must be between 1 and 4 for Always Free VM.Standard.A1.Flex"
  }
}

variable "memory_in_gbs" {
  type        = number
  description = "Memory in GBs for VM.Standard.A1.Flex shape"
  default     = 6

  validation {
    condition     = var.memory_in_gbs >= 6 && var.memory_in_gbs <= 24
    error_message = "memory_in_gbs must be between 6 and 24 GB for Always Free VM.Standard.A1.Flex"
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
  description = "SSH public key(s) for the instance"
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
  description = "Size of the boot volume in GBs (50-200 for Always Free)"
  default     = 50

  validation {
    condition     = var.boot_volume_size_in_gbs >= 50 && var.boot_volume_size_in_gbs <= 200
    error_message = "boot_volume_size_in_gbs must be between 50 and 200 GB for Always Free (total limit 200 GB)"
  }
}

variable "boot_volume_vpus_per_gb" {
  type        = string
  description = "VPUs per GB for the boot volume"
  default     = "10"
}

variable "block_volumes" {
  type = map(object({
    display_name        = string
    size_in_gbs         = number
    availability_domain = optional(string, null)
    instance_index      = number
    device              = optional(string, null)
    vpus_per_gb         = optional(string, "10")
    is_auto_tune_enabled = optional(bool, false)
  }))
  description = "Map of block volumes to create and attach"
  default     = {}
  
  validation {
    condition = alltrue([
      for v in var.block_volumes : v.instance_index >= 0 && v.instance_index < var.instance_count
    ])
    error_message = "instance_index must be between 0 and instance_count - 1"
  }
  
  validation {
    condition = alltrue([
      for v in var.block_volumes : v.size_in_gbs >= 50 && v.size_in_gbs <= 200
    ])
    error_message = "Each block volume size must be between 50 and 200 GB for Always Free (total limit 200 GB)"
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
  type        = map(map(string))
  description = "Defined tags to apply to all resources"
  default     = {}
}
