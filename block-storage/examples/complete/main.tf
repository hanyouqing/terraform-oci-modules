terraform {
  required_version = ">= 1.16.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.9"
    }
  }
}

provider "oci" {}

module "block_storage" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  volumes = var.volumes

  create_backups = var.create_backups

  backup_policies = var.backup_policies

  volume_attachments = var.volume_attachments

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
