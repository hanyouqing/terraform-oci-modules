terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "network_firewall" {
  source = "../../"

  compartment_id      = var.compartment_id
  display_name        = var.display_name
  subnet_id           = var.subnet_id
  availability_domain = var.availability_domain
  nsg_ids             = var.nsg_ids
  project             = "network-firewall"
  environment         = "complete"
}
