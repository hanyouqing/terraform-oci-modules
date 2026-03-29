locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//bastion"
}

inputs = {
  name                         = "${local.project}-${local.env}-bastion"
  bastion_type                 = "STANDARD"
  client_cidr_block_allow_list = ["0.0.0.0/0"]
  max_session_ttl_in_seconds   = 10800
  sessions                     = {}
}
