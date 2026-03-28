terraform {
  required_version = ">= 1.14.2"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

# Basic example: single NLB with TCP listener (Always Free compatible)
module "network_load_balancer" {
  source = "../../"

  compartment_id = var.compartment_id
  subnet_id      = var.subnet_id
  display_name   = "basic-nlb"
  is_private     = false

  backend_sets = {
    app-backend = {
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

  listeners = {
    tcp-80 = {
      default_backend_set_name = "app-backend"
      port                     = 80
      protocol                 = "TCP"
    }
  }

  project     = var.project
  environment = var.environment
}
