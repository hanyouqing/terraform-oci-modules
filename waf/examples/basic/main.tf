terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "waf" {
  source = "../../"

  compartment_id = var.compartment_id
  display_name   = var.display_name

  project     = "waf"
  environment = "development"
}
