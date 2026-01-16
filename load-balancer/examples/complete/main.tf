terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "load_balancer" {
  source = "../../"

  compartment_id = var.compartment_id
  display_name   = var.display_name
  shape          = var.shape
  is_private     = var.is_private

  shape_details = var.shape_details

  subnet_ids = var.subnet_ids
  nsg_ids    = var.nsg_ids

  backend_sets = var.backend_sets

  backends = var.backends

  listeners = var.listeners

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
