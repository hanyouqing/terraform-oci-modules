locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//nosql-database"
}

inputs = {
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
