# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------

variable "user_id" {
  description = "The OCID of the user to manage credentials for."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.user\\.", var.user_id))
    error_message = "The user_id must be a valid OCI user OCID (ocid1.user...)."
  }
}

# -----------------------------------------------------------------------------
# API Keys
# -----------------------------------------------------------------------------

variable "api_keys" {
  description = "Map of API signing keys to create. Each key requires a PEM-encoded RSA public key."
  type = map(object({
    key_value = string
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.api_keys : can(regex("^-----BEGIN (RSA )?PUBLIC KEY-----", v.key_value))])
    error_message = "Each api_key key_value must be a PEM-encoded RSA public key."
  }
}

# -----------------------------------------------------------------------------
# Auth Tokens
# -----------------------------------------------------------------------------

variable "auth_tokens" {
  description = "Map of auth tokens to create. Auth tokens are Oracle-compatible authentication tokens for services like Swift and HDFS."
  type = map(object({
    description = string
  }))
  default = {}
}

# -----------------------------------------------------------------------------
# Customer Secret Keys (S3-Compatible)
# -----------------------------------------------------------------------------

variable "customer_secret_keys" {
  description = "Map of customer secret keys to create. Used for Amazon S3-compatible API access to Object Storage."
  type = map(object({
    display_name = string
  }))
  default = {}
}

# -----------------------------------------------------------------------------
# SMTP Credentials
# -----------------------------------------------------------------------------

variable "smtp_credentials" {
  description = "Map of SMTP credentials to create. Used for sending email via OCI Email Delivery SMTP interface."
  type = map(object({
    description = string
  }))
  default = {}
}

# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------

variable "project" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "oci-modules"
}

variable "environment" {
  description = "Environment name (e.g., development, staging, production)."
  type        = string
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources (where supported)"
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all resources (where supported)"
  default     = {}
}
