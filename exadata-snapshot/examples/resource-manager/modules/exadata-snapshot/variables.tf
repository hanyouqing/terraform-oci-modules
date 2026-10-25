variable "database_id" {
  type        = string
  description = "OCID of the Exadata database to snapshot. Provider 9.11.0 added this resource for ExaDB-XS container database snapshots."

  validation {
    condition     = can(regex("^ocid1\\.database\\.oc1\\.", var.database_id))
    error_message = "database_id must be a database OCID."
  }
}

variable "snapshots" {
  type = map(object({
    name          = string
    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Snapshots to create for the database. The map key is only used inside Terraform. Each name must be unique on the database."

  validation {
    condition = alltrue([
      for snapshot in var.snapshots : length(snapshot.name) > 0 && length(snapshot.name) <= 255
    ])
    error_message = "Each snapshot name must be 1 to 255 characters."
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
  description = "Freeform tags merged onto every snapshot."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags merged onto every snapshot."
  default     = {}
}
