terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "bastion" {
  source = "../../"

  compartment_id   = var.compartment_id
  target_subnet_id = var.target_subnet_id
  bastion_type     = var.bastion_type
  name             = var.name

  client_cidr_block_allow_list = var.client_cidr_block_allow_list
  allow_world_open_access      = var.allow_world_open_access
  max_session_ttl_in_seconds   = var.max_session_ttl_in_seconds

  sessions = var.sessions

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
