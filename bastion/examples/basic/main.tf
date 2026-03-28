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

  # Recommended to restrict to your own public IP
  client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list

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
