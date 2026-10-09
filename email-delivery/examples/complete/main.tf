terraform {
  required_version = ">= 1.16.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.9"
    }
  }
}

provider "oci" {}

module "email_delivery" {
  source = "../../"

  compartment_id = var.compartment_id

  senders = var.senders

  suppressions = var.suppressions

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
}
