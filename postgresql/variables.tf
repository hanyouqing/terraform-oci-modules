variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the PostgreSQL database system."

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the PostgreSQL database system."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "description" {
  type        = string
  description = "Description of the PostgreSQL database system."
  default     = null
}

variable "db_version" {
  type        = string
  description = "PostgreSQL major version, for example 14 or 15. With allow_major_version_upgrade, changing this value upgrades in place."

  validation {
    condition     = can(regex("^[0-9]+$", var.db_version))
    error_message = "db_version must be a numeric major version such as 14."
  }
}

variable "shape" {
  type        = string
  description = "PostgreSQL shape. Flexible shapes require instance_ocpu_count and instance_memory_size_in_gbs."

  validation {
    condition     = length(var.shape) > 0
    error_message = "shape must be set."
  }
}

variable "instance_count" {
  type        = number
  description = "Number of database instances. Use 1 for a single node."
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "instance_ocpu_count" {
  type        = number
  description = "OCPU count for a flexible shape. Leave null for a fixed shape."
  default     = null

  validation {
    condition     = var.instance_ocpu_count == null || var.instance_ocpu_count >= 1
    error_message = "instance_ocpu_count must be at least 1 when set."
  }
}

variable "instance_memory_size_in_gbs" {
  type        = number
  description = "Memory in gigabytes for a flexible shape. Leave null for a fixed shape."
  default     = null

  validation {
    condition     = var.instance_memory_size_in_gbs == null || var.instance_memory_size_in_gbs >= 1
    error_message = "instance_memory_size_in_gbs must be at least 1 when set."
  }
}

variable "system_type" {
  type        = string
  description = "Database system type."
  default     = "OCI_OPTIMIZED_STORAGE"

  validation {
    condition     = var.system_type == "OCI_OPTIMIZED_STORAGE"
    error_message = "system_type must be OCI_OPTIMIZED_STORAGE."
  }
}

variable "config_id" {
  type        = string
  description = "OCID of a PostgreSQL configuration to attach. Leave null to use the service default."
  default     = null

  validation {
    condition     = var.config_id == null || can(regex("^ocid1\\.[a-z0-9]+\\.oc1\\.", var.config_id))
    error_message = "config_id must be an OCID."
  }
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Allow an in-place upgrade when db_version changes to a higher major version. Provider 9.11.0 added this argument. When false, changing db_version replaces the database system."
  default     = false
}

variable "upgrade_options" {
  type        = list(string)
  description = "Post-upgrade operations applied only when db_version changes and allow_major_version_upgrade is true. RUN_POST_UPGRADE_VACUUM is one operation the provider accepts. An empty list skips verification and vacuum."
  default     = []

  validation {
    condition     = length(var.upgrade_options) == 0 || var.allow_major_version_upgrade
    error_message = "upgrade_options requires allow_major_version_upgrade."
  }
}

variable "subnet_id" {
  type        = string
  description = "OCID of the private subnet for the database endpoint."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.subnet_id))
    error_message = "subnet_id must be a subnet OCID."
  }
}

variable "nsg_ids" {
  type        = set(string)
  description = "Network security groups attached to the database endpoint. Empty leaves the endpoint on the subnet security lists only."
  default     = []

  validation {
    condition = alltrue([
      for nsg_id in var.nsg_ids : can(regex("^ocid1\\.networksecuritygroup\\.oc1\\.", nsg_id))
    ])
    error_message = "Every nsg_ids entry must be a network security group OCID."
  }
}

variable "is_reader_endpoint_enabled" {
  type        = bool
  description = "Create a reader endpoint in addition to the primary endpoint."
  default     = false
}

variable "primary_db_endpoint_private_ip" {
  type        = string
  description = "Optional private IP for the primary endpoint. Leave null to let OCI allocate one."
  default     = null

  validation {
    condition     = var.primary_db_endpoint_private_ip == null || can(cidrhost("${var.primary_db_endpoint_private_ip}/32", 0))
    error_message = "primary_db_endpoint_private_ip must be an IPv4 address."
  }
}

variable "is_regionally_durable" {
  type        = bool
  description = "Store database data with regional durability."
  default     = true
}

variable "storage_system_type" {
  type        = string
  description = "Storage system type for the database."
  default     = "OCI_OPTIMIZED_STORAGE"

  validation {
    condition     = var.storage_system_type == "OCI_OPTIMIZED_STORAGE"
    error_message = "storage_system_type must be OCI_OPTIMIZED_STORAGE."
  }
}

variable "availability_domain" {
  type        = string
  description = "Availability domain for storage. Leave null to let OCI choose."
  default     = null
}

variable "storage_iops" {
  type        = string
  description = "Storage IOPS requested from the service. Leave null for the service default."
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "OCID of a Vault key used to encrypt the database. Leave null for Oracle-managed encryption."
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^ocid1\\.key\\.oc1\\.", var.kms_key_id))
    error_message = "kms_key_id must be a Vault key OCID."
  }
}

variable "admin_username" {
  type        = string
  description = "Administrator username. Do not use a PostgreSQL reserved role name."

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,62}$", var.admin_username))
    error_message = "admin_username must start with a letter and contain only letters, digits, and underscores."
  }
}

variable "admin_password_type" {
  type        = string
  description = "How the administrator password is supplied. VAULT_SECRET reads it from Vault. PLAIN_TEXT stores it in Terraform state."
  default     = "VAULT_SECRET"

  validation {
    condition     = contains(["VAULT_SECRET", "PLAIN_TEXT"], var.admin_password_type)
    error_message = "admin_password_type must be VAULT_SECRET or PLAIN_TEXT."
  }
}

variable "admin_password" {
  type        = string
  description = "Administrator password. Required only when admin_password_type is PLAIN_TEXT. The value is stored in Terraform state."
  default     = null
  sensitive   = true
}

variable "admin_password_secret_id" {
  type        = string
  description = "Vault secret OCID that holds the administrator password. Required when admin_password_type is VAULT_SECRET."
  default     = null

  validation {
    condition     = var.admin_password_secret_id == null || can(regex("^ocid1\\.vaultsecret\\.oc1\\.", var.admin_password_secret_id))
    error_message = "admin_password_secret_id must be a Vault secret OCID."
  }
}

variable "admin_password_secret_version" {
  type        = string
  description = "Vault secret version for the administrator password. Leave null to use the current version."
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
  description = "Defined tags applied to the database system."
  default     = {}
}

check "admin_password_material" {
  assert {
    condition = (
      var.admin_password_type == "PLAIN_TEXT" && var.admin_password != null && var.admin_password_secret_id == null
      ) || (
      var.admin_password_type == "VAULT_SECRET" && var.admin_password == null && var.admin_password_secret_id != null
    )
    error_message = "PLAIN_TEXT requires admin_password and no secret OCID. VAULT_SECRET requires admin_password_secret_id and no admin_password."
  }
}

check "flexible_shape_size" {
  assert {
    condition = (
      !strcontains(var.shape, "Flex") ||
      (var.instance_ocpu_count != null && var.instance_memory_size_in_gbs != null)
    )
    error_message = "A flexible PostgreSQL shape requires instance_ocpu_count and instance_memory_size_in_gbs."
  }
}
