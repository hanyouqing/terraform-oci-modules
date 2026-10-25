terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "sch" {
  source = "../../"

  compartment_id = var.compartment_id
  connectors     = var.connectors
  project        = "sch"
  environment    = "basic"
}
