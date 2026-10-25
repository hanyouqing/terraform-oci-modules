resource "oci_file_storage_file_system" "this" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name
  kms_key_id          = var.kms_key_id

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_file_storage_mount_target" "this" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "${var.display_name}-mt"
  subnet_id           = var.subnet_id
  hostname_label      = var.hostname_label
  nsg_ids             = var.nsg_ids

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_file_storage_export" "this" {
  export_set_id  = oci_file_storage_mount_target.this.export_set_id
  file_system_id = oci_file_storage_file_system.this.id
  path           = var.export_path

  export_options {
    source                         = var.export_source_cidr
    access                         = "READ_WRITE"
    identity_squash                = "ROOT"
    require_privileged_source_port = true
    is_anonymous_access_allowed    = false
  }
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/file-storage"
    Project     = var.project
    Environment = var.environment
  }
}
