
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
  default     = "file-storage-basic"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet OCID for the mount target."
}

variable "export_source_cidr" {
  type        = string
  description = "Client CIDR allowed to mount the export."
}
