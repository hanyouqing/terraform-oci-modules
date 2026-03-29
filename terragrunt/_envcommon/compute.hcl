locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//compute"
}

inputs = {
  shape          = "VM.Standard.E2.1.Micro"
  instance_count = 1
  display_name   = "${local.project}-${local.env}-instance"

  assign_public_ip                = true
  enable_monitoring               = true
  enable_management_agent         = false
  enable_pv_encryption_in_transit = true

  create_boot_volume      = false
  boot_volume_size_in_gbs = 50
  boot_volume_vpus_per_gb = "10"
  block_volumes           = {}
}
