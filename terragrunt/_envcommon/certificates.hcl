locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//certificates"
}

inputs = {
  certificate_authorities = {
    root-ca = {
      name         = "${local.project}-${local.env}-root-ca"
      kms_key_id   = dependency.vault.outputs.key_ids["ca-key"]
      common_name  = "${local.project} ${local.env} Root CA"
      organization = local.project
      country      = "US"
    }
  }

  certificates = {}

  project     = local.project
  environment = local.env
}
