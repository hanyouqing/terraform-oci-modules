terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "child_tenancy" {
  source = "../../"

  compartment_id = var.tenancy_id
  tenancy_name   = var.tenancy_name
  home_region    = var.home_region
  admin_email    = var.admin_email
}
