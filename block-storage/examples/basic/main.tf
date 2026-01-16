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

module "block_storage" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  volumes = {
    data-volume = {
      display_name        = "always-free-data-volume"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      size_in_gbs         = 50
      vpus_per_gb         = "10"
      is_auto_tune_enabled = false
      backup_policy_id    = null
      backup_type         = "FULL"
      freeform_tags       = {}
      defined_tags        = {}
    }
  }

  create_backups = false

  project     = "always-free"
  environment = "development"
}
