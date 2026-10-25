variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the connection."
}

variable "connection_type" {
  type        = string
  description = "GoldenGate Release 12 connection type."
}

variable "technology_type" {
  type        = string
  description = "GoldenGate Release 12 technology type."
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the private connection."
}

variable "vault_id" {
  type        = string
  description = "Vault OCID that holds the connection secrets."
}

variable "cluster_endpoint" {
  type        = string
  description = "Remote cluster endpoint."
}

variable "workspace_url" {
  type        = string
  description = "Workspace URL for the Release 12 connection."
}

variable "rest_endpoint" {
  type        = string
  description = "REST endpoint for the Release 12 connection."
}

variable "provider_id" {
  type        = string
  description = "Provider identifier for the Release 12 connection."
}

variable "auth_token_secret_id" {
  type        = string
  description = "Vault secret OCID for the auth token."
}

variable "deployment" {
  type = object({
    display_name       = string
    subnet_id          = string
    deployment_type    = string
    license_model      = string
    cpu_core_count     = number
    ogg_version        = string
    admin_username     = string
    password_secret_id = string
    is_public          = optional(bool, false)
    nsg_ids            = optional(set(string), [])
  })
  description = "Optional GoldenGate deployment. Null creates the connection only. The admin password is a Vault secret OCID."
  default     = null
}
