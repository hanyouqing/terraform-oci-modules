variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the GoldenGate connection."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the connection."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "description" {
  type        = string
  description = "Description of the connection."
  default     = null
}

variable "connection_type" {
  type        = string
  description = "GoldenGate connection type, for example GOLDENGATE or POSTGRESQL."

  validation {
    condition     = length(var.connection_type) > 0
    error_message = "connection_type must be set."
  }
}

variable "technology_type" {
  type        = string
  description = "Technology type paired with connection_type. Release 12 types use the fields added in provider 9.11.0."

  validation {
    condition     = length(var.technology_type) > 0
    error_message = "technology_type must be set."
  }
}

variable "username" {
  type        = string
  description = "Database or service username. Leave null when the connection type does not use one."
  default     = null
}

variable "host" {
  type        = string
  description = "Hostname of the source or target. Leave null when the connection type uses an endpoint URL instead."
  default     = null
}

variable "port" {
  type        = number
  description = "Port of the source or target."
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "port must be between 1 and 65535."
  }
}

variable "database_name" {
  type        = string
  description = "Database name on the source or target."
  default     = null
}

variable "connection_string" {
  type        = string
  description = "Connection string used by connection types that do not take host and port separately."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet used for a private connection. Leave null for a connection that does not use a private endpoint."
  default     = null

  validation {
    condition     = var.subnet_id == null || can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "nsg_ids" {
  type        = set(string)
  description = "Network security groups for the private connection."
  default     = []

  validation {
    condition = alltrue([
      for nsg_id in var.nsg_ids : can(regex("^ocid1\\.networksecuritygroup\\.oc1\\.", nsg_id))
    ])
    error_message = "Every nsg_ids entry must be a network security group OCID."
  }
}

variable "vault_id" {
  type        = string
  description = "Vault OCID that holds the connection secrets."
  default     = null

  validation {
    condition     = var.vault_id == null || can(regex("^ocid1\\.vault\\.oc1\\.", var.vault_id))
    error_message = "vault_id must be a Vault OCID."
  }
}

variable "does_use_secret_ids" {
  type        = bool
  description = "Tell GoldenGate that credentials are Vault secret OCIDs. Keep this true. The module does not accept plaintext secrets."
  default     = true
}

variable "password_secret_id" {
  type        = string
  description = "Vault secret OCID for the connection password."
  default     = null
}

variable "cluster_endpoint" {
  type        = string
  description = "Cluster endpoint used by Release 12 connections such as a remote data platform."
  default     = null
}

variable "workspace_url" {
  type        = string
  description = "Workspace URL used by Release 12 connections."
  default     = null
}

variable "rest_endpoint" {
  type        = string
  description = "REST endpoint used by Release 12 connections."
  default     = null
}

variable "provider_id" {
  type        = string
  description = "Provider identifier used by Release 12 connections."
  default     = null
}

variable "submit_mode" {
  type        = string
  description = "Submit mode used by Release 12 connections."
  default     = null
}

variable "rpc_cipher" {
  type        = string
  description = "RPC cipher used by Release 12 connections."
  default     = null
}

variable "tls_protocol" {
  type        = string
  description = "TLS protocol used by Release 12 connections."
  default     = null
}

variable "key_store_type" {
  type        = string
  description = "Key store type used by Release 12 connections."
  default     = null
}

variable "trust_store_type" {
  type        = string
  description = "Trust store type used by Release 12 connections."
  default     = null
}

variable "auth_secret_secret_id" {
  type        = string
  description = "Vault secret OCID for the Release 12 auth secret."
  default     = null
}

variable "auth_token_secret_id" {
  type        = string
  description = "Vault secret OCID for the Release 12 auth token."
  default     = null
}

variable "rest_auth_secret_key_secret_id" {
  type        = string
  description = "Vault secret OCID for the Release 12 REST auth secret key."
  default     = null
}

variable "key_store_secret_id" {
  type        = string
  description = "Vault secret OCID for the Release 12 key store."
  default     = null
}

variable "trust_store_secret_id" {
  type        = string
  description = "Vault secret OCID for the Release 12 trust store."
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
  description = "Defined tags applied to the connection and, when set, the deployment."
  default     = {}
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
  description = "Optional GoldenGate deployment. Null keeps this module at the connection only. The admin password is a Vault secret OCID."
  default     = null
}

check "secret_ids_are_vault_secrets" {
  assert {
    condition = alltrue([
      for secret_id in [
        var.password_secret_id,
        var.auth_secret_secret_id,
        var.auth_token_secret_id,
        var.rest_auth_secret_key_secret_id,
        var.key_store_secret_id,
        var.trust_store_secret_id,
      ] : secret_id == null || can(regex("^ocid1\\.vaultsecret\\.oc1\\.", secret_id))
    ])
    error_message = "Connection secrets must be Vault secret OCIDs."
  }
}

check "deployment_uses_vault_password" {
  assert {
    condition = var.deployment == null || (
      can(regex("^ocid1\\.vaultsecret\\.oc1\\.", var.deployment.password_secret_id)) &&
      contains(["LICENSE_INCLUDED", "BRING_YOUR_OWN_LICENSE"], var.deployment.license_model) &&
      var.deployment.cpu_core_count >= 1 &&
      var.deployment.cpu_core_count <= 24
    )
    error_message = "A deployment needs a Vault secret OCID, LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE, and 1 to 24 OCPUs."
  }
}

check "secret_ids_require_secret_mode" {
  assert {
    condition = var.does_use_secret_ids || alltrue([
      for secret_id in [
        var.password_secret_id,
        var.auth_secret_secret_id,
        var.auth_token_secret_id,
        var.rest_auth_secret_key_secret_id,
        var.key_store_secret_id,
        var.trust_store_secret_id,
      ] : secret_id == null
    ])
    error_message = "Set does_use_secret_ids when any Vault secret OCID is set."
  }
}
