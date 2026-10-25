resource "oci_psql_db_system" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  description    = var.description
  db_version     = var.db_version
  shape          = var.shape
  instance_count = var.instance_count
  system_type    = var.system_type
  config_id      = var.config_id

  instance_ocpu_count         = var.instance_ocpu_count
  instance_memory_size_in_gbs = var.instance_memory_size_in_gbs

  # In-place major version migration, added in provider 9.11.0.
  # When false, a db_version change replaces the database system.
  allow_major_version_upgrade = var.allow_major_version_upgrade
  upgrade_options             = length(var.upgrade_options) == 0 ? null : var.upgrade_options

  network_details {
    subnet_id                      = var.subnet_id
    nsg_ids                        = length(var.nsg_ids) == 0 ? null : var.nsg_ids
    is_reader_endpoint_enabled     = var.is_reader_endpoint_enabled
    primary_db_endpoint_private_ip = var.primary_db_endpoint_private_ip
  }

  storage_details {
    is_regionally_durable = var.is_regionally_durable
    system_type           = var.storage_system_type
    availability_domain   = var.availability_domain
    iops                  = var.storage_iops
    kms_key_id            = var.kms_key_id
  }

  credentials {
    username = var.admin_username

    password_details {
      password_type  = var.admin_password_type
      password       = var.admin_password_type == "PLAIN_TEXT" ? var.admin_password : null
      secret_id      = var.admin_password_type == "VAULT_SECRET" ? var.admin_password_secret_id : null
      secret_version = var.admin_password_type == "VAULT_SECRET" ? var.admin_password_secret_version : null
    }
  }

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/postgresql"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
