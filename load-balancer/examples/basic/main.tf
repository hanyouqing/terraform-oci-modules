terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "load_balancer" {
  source = "../../"

  compartment_id = var.compartment_id
  display_name   = "always-free-lb"
  shape          = "flexible"
  is_private     = false

  shape_details = {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  subnet_ids = var.subnet_ids

  backend_sets = {
    backend-set-1 = {
      policy = "ROUND_ROBIN"
      health_checker = {
        protocol            = "HTTP"
        port                = 80
        url_path            = "/"
        interval_ms         = 10000
        timeout_in_millis   = 3000
        retries             = 3
        response_body_regex = ".*"
      }
      ssl_configuration = null
    }
  }

  listeners = {
    listener-1 = {
      default_backend_set_name = "backend-set-1"
      port                     = 80
      protocol                 = "HTTP"
      ssl_configuration        = null
      connection_configuration = {
        idle_timeout_in_seconds = 60
      }
    }
  }

  project     = "always-free"
  environment = "development"
}
