locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//apm"
}

inputs = {
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
