terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "postgresql" {
  source = "../../"

  compartment_id              = var.compartment_id
  display_name                = "pg-basic"
  db_version                  = "14"
  shape                       = "PostgreSQL.VM.Standard.E4.Flex"
  instance_count              = 1
  instance_ocpu_count         = 2
  instance_memory_size_in_gbs = 10
  subnet_id                   = var.subnet_id
  admin_username              = var.admin_username
  admin_password_secret_id    = var.admin_password_secret_id

  project     = "postgresql"
  environment = "development"
}
