locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
  compartment_id   = local.environment_vars.locals.compartment_id
}

terraform {
  source = "${get_repo_root()}/apm"
}

inputs = {
  compartment_id = local.compartment_id

  apm_domains = {
    main = {
      display_name = "${local.project}-${local.env}-apm"
      description  = "APM domain for ${local.project} ${local.env}"
      is_free_tier = true
    }
  }

  synthetics_monitors = {}

  project     = local.project
  environment = local.env
}
