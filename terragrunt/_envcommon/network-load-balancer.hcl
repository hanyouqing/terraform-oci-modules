locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.env_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//network-load-balancer"
}

inputs = {
  compartment_id = get_env("TF_VAR_compartment_id", "")
  display_name   = "${local.project}-${local.env}-nlb"
  is_private     = false

  is_preserve_source_destination = false
  is_symmetric_hash_enabled      = false
  nsg_ids                        = []
  reserved_ips                   = []

  backend_sets = {
    app-backend-set = {
      policy = "FIVE_TUPLE"
      health_checker = {
        protocol           = "TCP"
        port               = 80
        interval_in_millis = 10000
        timeout_in_millis  = 3000
        retries            = 3
      }
    }
  }
  backends = {}
  listeners = {
    tcp-listener = {
      default_backend_set_name = "app-backend-set"
      port                     = 80
      protocol                 = "TCP"
    }
  }
}
