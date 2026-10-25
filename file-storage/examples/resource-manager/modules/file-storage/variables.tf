variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the file system and mount target."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for the file system and mount target."

  validation {
    condition     = length(var.availability_domain) > 0
    error_message = "availability_domain must be set."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the file system. The mount target appends -mt."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 250
    error_message = "display_name must be 1 to 250 characters."
  }
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet for the mount target. Use a private subnet."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "export_path" {
  type        = string
  description = "Export path clients use in the mount command."
  default     = "/export"

  validation {
    condition     = can(regex("^/", var.export_path))
    error_message = "export_path must start with /."
  }
}

variable "export_source_cidr" {
  type        = string
  description = "Client CIDR allowed to mount the export. Use the VCN or application CIDR."

  validation {
    condition     = can(cidrnetmask(var.export_source_cidr)) && var.export_source_cidr != "0.0.0.0/0"
    error_message = "export_source_cidr must be a CIDR other than 0.0.0.0/0."
  }
}

variable "hostname_label" {
  type        = string
  description = "DNS label for the mount target. Null omits it."
  default     = null
}

variable "nsg_ids" {
  type        = set(string)
  description = "NSG OCIDs for the mount target. Allow NFS only from export_source_cidr."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "Vault key OCID for the file system. Null uses Oracle-managed encryption."
  default     = null
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
  description = "Defined tags applied to the file system and mount target."
  default     = {}
}
