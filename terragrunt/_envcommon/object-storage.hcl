locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)

  # Aligns with root.hcl state_bucket formula: <project>-tfstate
  state_bucket_name = "${local.project}-tfstate"
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../object-storage"
}

inputs = {
  region = local.region

  buckets = {
    tfstate = {
      name                  = local.state_bucket_name
      access_type           = "NoPublicAccess"
      storage_tier          = "Standard"
      versioning            = "Enabled"
      auto_tiering          = "Disabled"
      object_events_enabled = false
      freeform_tags = {
        Purpose = "terraform-state"
      }
    }
  }

  lifecycle_policies = {}
  preauth_requests   = {}
}
