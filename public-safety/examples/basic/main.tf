terraform {
  required_version = ">= 1.5.0, < 1.6.0"
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

  project     = "public-safety"
  environment = "development"
}
