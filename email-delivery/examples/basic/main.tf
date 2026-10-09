terraform {
  required_version = ">= 1.16.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.9"
    }
  }
}

provider "oci" {}

module "email_delivery" {
  source = "../../"

  compartment_id = var.compartment_id

  senders = {
    sender-1 = {
      email_address = var.sender_email
    }
  }

  project     = "always-free"
  environment = "development"
}
