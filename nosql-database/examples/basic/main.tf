terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "nosql_database" {
  source = "../../"

  compartment_id = var.compartment_id

  tables = {
    users = {
      name          = "users"
      ddl_statement = "CREATE TABLE users (id INTEGER, name STRING, email STRING, created_at TIMESTAMP(0), PRIMARY KEY (id))"

      # Always Free defaults
      max_read_units     = 50
      max_write_units    = 50
      max_storage_in_gbs = 25
      capacity_mode      = "PROVISIONED"
    }
  }

  project     = "always-free"
  environment = "development"
}
