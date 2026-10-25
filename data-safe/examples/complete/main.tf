terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "data_safe" {
  source = "../../"

  tenancy_ocid              = var.tenancy_ocid
  compartment_id            = var.compartment_id
  private_endpoint          = var.private_endpoint
  target_databases          = var.target_databases
  target_database_passwords = var.target_database_passwords

  project     = var.project
  environment = var.environment
}
