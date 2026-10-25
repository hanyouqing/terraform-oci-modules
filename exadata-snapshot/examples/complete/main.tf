terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "database_snapshot" {
  source = "../../"

  database_id = var.database_id

  snapshots = {
    before-upgrade = {
      name = "before-upgrade"
    }
    after-upgrade = {
      name = "after-upgrade"
    }
  }

  project     = "exadb"
  environment = "production"
}
