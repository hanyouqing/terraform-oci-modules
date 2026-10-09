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

module "logging" {
  source = "../../"

  compartment_id = var.compartment_id

  log_groups = var.log_groups

  logs = var.logs

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
}
