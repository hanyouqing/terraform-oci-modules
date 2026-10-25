terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "functions" {
  source = "../../"

  compartment_id = var.compartment_id
  display_name   = var.display_name
  subnet_ids     = var.subnet_ids
  shape          = var.shape
  functions      = var.functions
  project        = "functions"
  environment    = "complete"
}
