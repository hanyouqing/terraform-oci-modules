locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
  compartment_id   = local.environment_vars.locals.compartment_id
}

terraform {
  source = "${get_repo_root()}/site-to-site-vpn"
}

inputs = {
  compartment_id = local.compartment_id

  cpes = {}

  ipsec_connections = {}

  project     = local.project
  environment = local.env
}
