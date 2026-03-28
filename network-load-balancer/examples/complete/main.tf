terraform {
  required_version = ">= 1.14.2"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

# Complete example: NLB with multiple listeners, backends, and protocols
module "network_load_balancer" {
  source = "../../"

  compartment_id                 = var.compartment_id
  subnet_id                      = var.subnet_id
  display_name                   = var.display_name
  is_private                     = var.is_private
  is_preserve_source_destination = var.is_preserve_source_destination
  is_symmetric_hash_enabled      = var.is_symmetric_hash_enabled
  nsg_ids                        = var.nsg_ids
  reserved_ips                   = var.reserved_ips

  backend_sets = {
    http-backend = {
      policy = "FIVE_TUPLE"
      health_checker = {
        protocol            = "HTTP"
        port                = 80
        url_path            = "/health"
        return_code         = 200
        interval_in_millis  = 10000
        timeout_in_millis   = 3000
        retries             = 3
        response_body_regex = ".*OK.*"
      }
    }
    tcp-backend = {
      policy = "THREE_TUPLE"
      health_checker = {
        protocol           = "TCP"
        port               = 443
        interval_in_millis = 10000
        timeout_in_millis  = 3000
        retries            = 3
      }
    }
    udp-backend = {
      policy = "FIVE_TUPLE"
      health_checker = {
        protocol           = "TCP"
        port               = 53
        interval_in_millis = 30000
        timeout_in_millis  = 5000
        retries            = 5
      }
    }
  }

  backends = {
    http-server-1 = {
      backend_set_name = "http-backend"
      ip_address       = "10.0.10.10"
      port             = 80
      weight           = 1
    }
    http-server-2 = {
      backend_set_name = "http-backend"
      ip_address       = "10.0.10.11"
      port             = 80
      weight           = 1
    }
    tcp-server-1 = {
      backend_set_name = "tcp-backend"
      ip_address       = "10.0.10.10"
      port             = 443
      weight           = 1
    }
    tcp-server-2 = {
      backend_set_name = "tcp-backend"
      ip_address       = "10.0.10.11"
      port             = 443
      weight           = 1
    }
    dns-server-1 = {
      backend_set_name = "udp-backend"
      ip_address       = "10.0.20.10"
      port             = 53
      weight           = 1
    }
  }

  listeners = {
    http-listener = {
      default_backend_set_name = "http-backend"
      port                     = 80
      protocol                 = "TCP"
    }
    https-listener = {
      default_backend_set_name = "tcp-backend"
      port                     = 443
      protocol                 = "TCP"
    }
    dns-listener = {
      default_backend_set_name = "udp-backend"
      port                     = 53
      protocol                 = "UDP"
    }
  }

  project       = var.project
  environment   = var.environment
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
