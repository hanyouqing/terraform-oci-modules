terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
    }
  }
}

module "bastion" {
  source = "../../"

  compartment_id   = var.compartment_id
  target_subnet_id = var.target_subnet_id
  bastion_type     = "STANDARD"
  name             = "always-free-bastion"

  # Recommended: export TF_VAR_bastion_allowed_cidr='203.0.113.10/32'
  # World-open 0.0.0.0/0 is blocked unless allow_world_open_access=true (lab only).
  client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
  allow_world_open_access      = false

  sessions = {
    "test-session" = {
      display_name       = "test-session"
      public_key_content = var.ssh_public_key
      session_type       = "PORT_FORWARDING"
      # Other fields optional
    }
  }

  project     = "always-free"
  environment = "development"
}
