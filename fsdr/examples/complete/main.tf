terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "fsdr" {
  source = "../../"

  compartment_id = var.compartment_id
  display_name   = var.display_name
  log_bucket     = var.log_bucket
  log_namespace  = var.log_namespace
  association    = var.association
  members        = var.members
  project        = "fsdr"
  environment    = "complete"
}
