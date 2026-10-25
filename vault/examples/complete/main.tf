terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "vault" {
  source = "../../"

  compartment_id     = var.compartment_id
  vault_display_name = var.vault_display_name
  vault_type         = var.vault_type

  keys = var.keys

  secrets = var.secrets

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
