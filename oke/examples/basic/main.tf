terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "oke" {
  source = "../../"

  compartment_id     = var.compartment_id
  name               = var.name
  kubernetes_version = var.kubernetes_version
  vcn_id             = var.vcn_id
  endpoint_subnet_id = var.endpoint_subnet_id

  project     = "oke"
  environment = "development"
}
