terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "object_storage" {
  source = "../../"

  compartment_id = var.compartment_id
  region         = var.region

  buckets = var.buckets

  lifecycle_policies = var.lifecycle_policies

  preauth_requests = var.preauth_requests

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
