locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../compute"
}

# Default: Always Free AMD micro, no public IP (least privilege).
# Edge/dev leaves that need a public VNIC must set assign_public_ip = true.
# For Always Free ARM edge profile, override in the leaf:
#   shape = "VM.Standard.A1.Flex"
#   ocpus = 2
#   memory_in_gbs = 12
#   boot_volume_size_in_gbs = 50
#   instance_count = 1
#   image_operating_system_version = "9"
# Pass base64 user_data from the caller; this module never embeds application scripts.
inputs = {
  shape          = "VM.Standard.E2.1.Micro"
  instance_count = 1
  display_name   = "${local.project}-${local.env}-instance"

  assign_public_ip                = false
  enable_monitoring               = true
  enable_management_agent         = false
  enable_pv_encryption_in_transit = true

  create_boot_volume      = false
  boot_volume_size_in_gbs = 50
  boot_volume_vpus_per_gb = "10"
  block_volumes           = {}

  instance_options = {
    are_legacy_imds_endpoints_disabled = true
  }
}
