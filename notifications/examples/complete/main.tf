terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "notifications" {
  source = "../../"

  compartment_id = var.compartment_id

  topics = var.topics

  subscriptions = var.subscriptions

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
}
