locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
  compartment_id   = local.environment_vars.locals.compartment_id
}

terraform {
  source = "${get_repo_root()}/nosql-database"
}

inputs = {
  compartment_id = local.compartment_id

  tables = {
    app-data = {
      name          = "${local.project}-${local.env}-data"
      ddl_statement = "CREATE TABLE ${local.project}_${local.env}_data (id STRING, data JSON, created_at TIMESTAMP(0), PRIMARY KEY (id))"

      max_read_units     = 50
      max_write_units    = 50
      max_storage_in_gbs = 25
      capacity_mode      = "PROVISIONED"
    }
  }

  indexes = {}

  project     = local.project
  environment = local.env
}
