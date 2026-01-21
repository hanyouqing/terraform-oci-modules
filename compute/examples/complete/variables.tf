variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet"
}

variable "shape" {
  type        = string
  description = "Instance shape"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_count" {
  type        = number
  description = "Number of instances"
  default     = 1
}

variable "display_name" {
  type        = string
  description = "Display name"
  default     = "production-instance"
}

variable "ocpus" {
  type        = number
  description = "Number of OCPUs for A1.Flex"
  default     = 2
}

variable "memory_in_gbs" {
  type        = number
  description = "Memory in GBs for A1.Flex"
  default     = 12
}

variable "availability_domain" {
  type        = string
  description = "Availability domain"
  default     = null
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign public IP"
  default     = true
}

variable "hostname_label" {
  type        = string
  description = "Hostname label"
  default     = null
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys"
}

variable "user_data" {
  type        = string
  description = "User data script"
  default     = null
}

variable "nsg_ids" {
  type        = list(string)
  description = "Network Security Group IDs"
  default     = []
}

variable "private_ip" {
  type        = string
  description = "Private IP address"
  default     = null
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable monitoring"
  default     = true
}

variable "enable_management_agent" {
  type        = bool
  description = "Enable management agent"
  default     = false
}

variable "enable_pv_encryption_in_transit" {
  type        = bool
  description = "Enable PV encryption in transit"
  default     = true
}

variable "create_boot_volume" {
  type        = bool
  description = "Create separate boot volume"
  default     = false
}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "Boot volume size in GBs"
  default     = 50
}

variable "boot_volume_vpus_per_gb" {
  type        = string
  description = "Boot volume VPUs per GB"
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
  description = "Block volumes"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags"
  default     = {}
}
