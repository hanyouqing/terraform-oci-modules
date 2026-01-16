terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "vault" {
  source = "../../"

  compartment_id     = var.compartment_id
  vault_display_name = "always-free-vault"
  vault_type         = "DEFAULT"

  keys = {
    master-key = {
      display_name   = "always-free-master-key"
      algorithm      = "AES"
      length         = 32
      curve_id       = null
      protection_mode = "SOFTWARE"
    }
  }

  secrets = {}

  project     = "always-free"
  environment = "development"
}
