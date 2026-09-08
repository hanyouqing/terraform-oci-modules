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
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../load-balancer"
}

inputs = {
  display_name = "${local.project}-${local.env}-lb"
  shape        = "flexible"
  # Default private; edge/dev leaves that need a public LB must set is_private = false.
  is_private = true

  shape_details = {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  nsg_ids = []
  backend_sets = {
    app-backend-set = {
      policy = "ROUND_ROBIN"
      health_checker = {
        protocol            = "HTTP"
        port                = 80
        url_path            = "/health"
        interval_ms         = 10000
        timeout_in_millis   = 3000
        retries             = 3
        response_body_regex = ".*"
      }
      ssl_configuration = null
    }
  }
  backends = {}
  listeners = {
    http-listener = {
      default_backend_set_name = "app-backend-set"
      port                     = 80
      protocol                 = "HTTP"
      ssl_configuration        = null
      connection_configuration = null
    }
  }
}
