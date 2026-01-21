terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "bastion" {
  source = "../../"

  compartment_id   = var.compartment_id
  target_subnet_id = var.target_subnet_id
  bastion_type     = "STANDARD"
  name             = "always-free-bastion"

  client_cidr_block_allow_list = ["0.0.0.0/0"]

  sessions = {}

  project     = "always-free"
  environment = "development"
}
