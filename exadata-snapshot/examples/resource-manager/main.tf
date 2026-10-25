module "database_snapshot" {
  source = "./modules/exadata-snapshot"

  database_id = var.database_id

  snapshots = {
    nightly = {
      name = "nightly"
    }
  }

  project     = "exadb"
  environment = "development"
}
