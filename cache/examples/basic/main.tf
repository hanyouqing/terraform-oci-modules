terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "cache" {
  source = "../../"

  compartment_id     = var.compartment_id
  display_name       = var.display_name
  subnet_id          = var.subnet_id
  software_version   = var.software_version
  node_count         = var.node_count
  node_memory_in_gbs = var.node_memory_in_gbs

  project     = "cache"
  environment = "development"
}
