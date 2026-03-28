variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where certificate authorities and certificates will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "certificate_authorities" {
  type = map(object({
    name        = string
    description = optional(string, "")
    kms_key_id  = string

    # CA config
    config_type                     = optional(string, "ROOT_CA_GENERATED_INTERNALLY")
    issuer_certificate_authority_id = optional(string, null)
    signing_algorithm               = optional(string, "SHA256_WITH_RSA")
    key_algorithm                   = optional(string, "RSA2048")
    version_name                    = optional(string, null)

    # Subject
    common_name         = string
    country             = optional(string, null)
    organization        = optional(string, null)
    organizational_unit = optional(string, null)
    state_name          = optional(string, null)
    locality            = optional(string, null)

    # Validity (ISO 8601 timestamps)
    time_of_validity_not_before = optional(string, null)
    time_of_validity_not_after  = optional(string, null)

    # Rules
    certificate_authority_max_validity_duration = optional(string, null)
    leaf_certificate_max_validity_duration      = optional(string, null)

    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of Certificate Authorities to create. Always Free: 5 CAs per tenancy."
  default     = {}

  validation {
    condition = alltrue([
      for ca in var.certificate_authorities : contains([
        "ROOT_CA_GENERATED_INTERNALLY",
        "SUBORDINATE_CA_ISSUED_BY_INTERNAL_CA"
      ], ca.config_type)
    ])
    error_message = "config_type must be 'ROOT_CA_GENERATED_INTERNALLY' or 'SUBORDINATE_CA_ISSUED_BY_INTERNAL_CA'."
  }

  validation {
    condition = alltrue([
      for ca in var.certificate_authorities : contains([
        "SHA256_WITH_RSA", "SHA384_WITH_RSA", "SHA512_WITH_RSA",
        "SHA256_WITH_ECDSA", "SHA384_WITH_ECDSA", "SHA512_WITH_ECDSA"
      ], ca.signing_algorithm)
    ])
    error_message = "signing_algorithm must be one of: SHA256_WITH_RSA, SHA384_WITH_RSA, SHA512_WITH_RSA, SHA256_WITH_ECDSA, SHA384_WITH_ECDSA, SHA512_WITH_ECDSA."
  }

  validation {
    condition = alltrue([
      for ca in var.certificate_authorities : contains([
        "RSA2048", "RSA4096", "ECDSA_P256", "ECDSA_P384"
      ], ca.key_algorithm)
    ])
    error_message = "key_algorithm must be one of: RSA2048, RSA4096, ECDSA_P256, ECDSA_P384."
  }
}

variable "certificates" {
  type = map(object({
    name        = string
    description = optional(string, "")

    # Certificate config
    config_type              = optional(string, "ISSUED_BY_INTERNAL_CA")
    certificate_profile_type = optional(string, "TLS_SERVER_OR_CLIENT")
    key_algorithm            = optional(string, "RSA2048")
    signature_algorithm      = optional(string, "SHA256_WITH_RSA")

    # Reference to CA — either a key in certificate_authorities or a direct OCID
    ca_key                          = optional(string, null)
    issuer_certificate_authority_id = optional(string, null)

    # Subject
    common_name         = string
    country             = optional(string, null)
    organization        = optional(string, null)
    organizational_unit = optional(string, null)
    state_name          = optional(string, null)
    locality            = optional(string, null)

    # Subject Alternative Names
    subject_alternative_names = optional(list(object({
      type  = string
      value = string
    })), [])

    # Validity (ISO 8601 timestamps)
    time_of_validity_not_before = optional(string, null)
    time_of_validity_not_after  = optional(string, null)

    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of certificates to create. Always Free: 150 certificates per tenancy. Use ca_key to reference a CA in certificate_authorities, or issuer_certificate_authority_id for an external CA OCID."
  default     = {}

  validation {
    condition = alltrue([
      for cert in var.certificates : contains([
        "ISSUED_BY_INTERNAL_CA",
        "MANAGED_EXTERNALLY_ISSUED_BY_INTERNAL_CA"
      ], cert.config_type)
    ])
    error_message = "config_type must be 'ISSUED_BY_INTERNAL_CA' or 'MANAGED_EXTERNALLY_ISSUED_BY_INTERNAL_CA'."
  }

  validation {
    condition = alltrue([
      for cert in var.certificates : contains([
        "TLS_SERVER_OR_CLIENT", "TLS_SERVER", "TLS_CLIENT", "TLS_CODE_SIGN"
      ], cert.certificate_profile_type)
    ])
    error_message = "certificate_profile_type must be one of: TLS_SERVER_OR_CLIENT, TLS_SERVER, TLS_CLIENT, TLS_CODE_SIGN."
  }

  validation {
    condition = alltrue([
      for cert in var.certificates : cert.ca_key != null || cert.issuer_certificate_authority_id != null
    ])
    error_message = "Each certificate must have either ca_key (referencing a key in certificate_authorities) or issuer_certificate_authority_id (external CA OCID)."
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
  type        = map(string)
  description = "Defined tags to apply to all resources"
  default     = {}
}
