
variable "compartment_id" {
  type        = string
  description = "Compartment OCID."
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for the file system and mount target."
}

variable "display_name" {
  type        = string
  description = "File system display name."
  default     = "file-storage-complete"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the mount target."
}

variable "export_source_cidr" {
  type        = string
  description = "Client CIDR allowed to mount the export."
}

variable "export_path" {
  type        = string
  description = "Export path."
  default     = "/export"
}

variable "hostname_label" {
  type        = string
  description = "DNS label for the mount target."
  default     = null
}

variable "nsg_ids" {
  type        = set(string)
  description = "NSG OCIDs for the mount target."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "Vault key OCID for the file system."
  default     = null
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "file-storage"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
