terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "monitoring" {
  source = "../../"

  compartment_id = var.compartment_id

  alarms = var.alarms

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
}
