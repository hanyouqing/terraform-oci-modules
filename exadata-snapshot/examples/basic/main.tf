terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.13"
    }
  }
}

module "database_snapshot" {
  source = "../../"

  database_id = var.database_id

  snapshots = {
    nightly = {
      name = "nightly"
    }
  }

  project     = "exadb"
  environment = "development"
}
