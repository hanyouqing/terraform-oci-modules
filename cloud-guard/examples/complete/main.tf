terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "cloud_guard" {
  source = "../../"

  tenancy_ocid     = var.tenancy_ocid
  reporting_region = var.reporting_region
  targets          = var.targets

  project     = var.project
  environment = var.environment
}
