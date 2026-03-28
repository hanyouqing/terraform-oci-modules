terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "vpn" {
  source = "../../"

  compartment_id = var.compartment_id

  cpes = {
    on-prem = {
      display_name = "on-premises-router"
      ip_address   = var.cpe_ip_address
    }
  }

  ipsec_connections = {
    main-vpn = {
      display_name  = "site-to-site-vpn"
      drg_id        = var.drg_id
      cpe_key       = "on-prem"
      static_routes = ["10.0.0.0/16"]
    }
  }

  project     = "always-free"
  environment = "development"
}
