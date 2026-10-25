terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "public_safety" {
  source = "../../"

  compartment_id                = var.compartment_id
  identity_domain_url           = var.identity_domain_url
  admin_identity_domain_user_id = var.admin_identity_domain_user_id
  display_name                  = var.display_name

  project     = var.project
  environment = var.environment

  freeform_tags = {
    "Service" = "public-safety"
    "Release" = "provider-9.11.0"
  }

  defined_tags = var.defined_tags
}
