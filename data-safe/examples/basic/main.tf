terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "data_safe" {
  source = "../../"

  tenancy_ocid = var.tenancy_ocid
  is_enabled   = true

  project     = "data-safe"
  environment = "development"
}
