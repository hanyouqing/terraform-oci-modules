terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "postgresql" {
  source = "../../"

  compartment_id              = var.compartment_id
  display_name                = "pg-prod"
  description                 = "PostgreSQL with in-place major version upgrades enabled"
  db_version                  = var.db_version
  shape                       = "PostgreSQL.VM.Standard.E4.Flex"
  instance_count              = 1
  instance_ocpu_count         = var.instance_ocpu_count
  instance_memory_size_in_gbs = var.instance_memory_size_in_gbs
  subnet_id                   = var.subnet_id
  nsg_ids                     = var.nsg_ids
  kms_key_id                  = var.kms_key_id
  admin_username              = var.admin_username
  admin_password_secret_id    = var.admin_password_secret_id

  allow_major_version_upgrade = true
  upgrade_options             = ["RUN_POST_UPGRADE_VACUUM"]

  project     = "postgresql"
  environment = "production"
}
