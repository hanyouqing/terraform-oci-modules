terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "file_storage" {
  source = "../../"

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = var.display_name
  subnet_id           = var.subnet_id
  export_source_cidr  = var.export_source_cidr
  export_path         = var.export_path
  hostname_label      = var.hostname_label
  nsg_ids             = var.nsg_ids
  kms_key_id          = var.kms_key_id

  project     = var.project
  environment = var.environment
}
