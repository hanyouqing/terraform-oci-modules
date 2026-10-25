terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
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
