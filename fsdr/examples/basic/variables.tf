variable "compartment_id" {
  type        = string
  description = "Compartment OCID."
}

variable "display_name" {
  type        = string
  description = "DR protection group display name."
  default     = "fsdr-demo"
}

variable "log_bucket" {
  type        = string
  description = "Object Storage bucket for DR logs."
}

variable "log_namespace" {
  type        = string
  description = "Object Storage namespace for DR logs."
}

variable "association" {
  type = object({
    role        = string
    peer_id     = optional(string)
    peer_region = optional(string)
  })
  description = "Optional peer association."
  default     = null
}

variable "members" {
  type = list(object({
    member_id   = string
    member_type = string
  }))
  description = "Optional members."
  default     = []
}
