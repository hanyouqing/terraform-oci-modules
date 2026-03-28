locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.env_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//block-storage"
}

inputs = {
  compartment_id = get_env("TF_VAR_compartment_id", "")
  tenancy_ocid   = get_env("TF_VAR_tenancy_ocid", "")

  create_backups     = false
  backup_policies    = {}
  volume_attachments = {}
}
