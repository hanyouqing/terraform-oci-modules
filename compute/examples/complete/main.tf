terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

module "compute" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  subnet_id      = var.subnet_id

  shape          = var.shape
  instance_count = var.instance_count
  display_name   = var.display_name

  ocpus         = var.ocpus
  memory_in_gbs = var.memory_in_gbs

  availability_domain = var.availability_domain
  assign_public_ip    = var.assign_public_ip
  hostname_label      = var.hostname_label
  ssh_public_keys     = var.ssh_public_keys
  user_data           = var.user_data

  nsg_ids    = var.nsg_ids
  private_ip = var.private_ip

  enable_monitoring               = var.enable_monitoring
  enable_management_agent         = var.enable_management_agent
  enable_pv_encryption_in_transit = var.enable_pv_encryption_in_transit

  create_boot_volume      = var.create_boot_volume
  boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  boot_volume_vpus_per_gb = var.boot_volume_vpus_per_gb

  block_volumes = var.block_volumes

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
