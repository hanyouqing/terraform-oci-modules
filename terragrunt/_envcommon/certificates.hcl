locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
  compartment_id   = local.environment_vars.locals.compartment_id
}

terraform {
  source = "${get_repo_root()}/certificates"
}

inputs = {
  compartment_id = local.compartment_id

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
