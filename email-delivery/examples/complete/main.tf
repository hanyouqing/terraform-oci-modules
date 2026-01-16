terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "email_delivery" {
  source = "../../"

  compartment_id = var.compartment_id

  senders = var.senders

  suppressions = var.suppressions

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
}
