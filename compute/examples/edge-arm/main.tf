terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
    }
  }
}

# Always Free ARM profile commonly used for a single public edge instance:
# VM.Standard.A1.Flex with 2 OCPU / 12 GB / 50 GB boot (within 4 OCPU / 24 GB tenancy quota).
# user_data must be supplied by the caller as base64; this example leaves it null.
module "compute" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  subnet_id      = var.subnet_id

  shape                   = "VM.Standard.A1.Flex"
  instance_count          = 1
  display_name            = var.display_name
  ocpus                   = 2
  memory_in_gbs           = 12
  boot_volume_size_in_gbs = 50

  image_operating_system         = "Oracle Linux"
  image_operating_system_version = "9"

  assign_public_ip = true
  hostname_label   = var.hostname_label
  ssh_public_keys  = var.ssh_public_keys
  user_data        = var.user_data
  nsg_ids          = var.nsg_ids

  enable_monitoring               = true
  enable_management_agent         = false
  enable_pv_encryption_in_transit = true

  instance_options = {
    are_legacy_imds_endpoints_disabled = true
  }

  project     = var.project
  environment = var.environment
}
