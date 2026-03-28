locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
}

terraform {
  source = "${get_repo_root()}/credentials"
}

inputs = {
  api_keys             = {}
  auth_tokens          = {}
  customer_secret_keys = {}
  smtp_credentials     = {}

  project     = local.project
  environment = local.env
}
