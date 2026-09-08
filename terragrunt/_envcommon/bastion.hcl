locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)

  # Production: set TF_VAR_bastion_allowed_cidr to your admin IP/32. No world-open default.
  bastion_cidr = trimspace(get_env("TF_VAR_bastion_allowed_cidr", ""))
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../bastion"
}

inputs = {
  name                         = "${local.project}-${local.env}-bastion"
  bastion_type                 = "STANDARD"
  client_cidr_block_allow_list = local.bastion_cidr != "" ? [local.bastion_cidr] : []
  allow_world_open_access      = false
  max_session_ttl_in_seconds   = 10800
  sessions                     = {}
}
