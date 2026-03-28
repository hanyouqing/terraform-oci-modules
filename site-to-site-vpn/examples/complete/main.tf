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
    # Primary site CPE
    primary-site = {
      display_name = "${var.project}-primary-cpe"
      ip_address   = var.primary_cpe_ip
    }

    # Secondary/DR site CPE
    dr-site = {
      display_name = "${var.project}-dr-cpe"
      ip_address   = var.dr_cpe_ip
    }
  }

  ipsec_connections = {
    # Primary site VPN
    primary-vpn = {
      display_name  = "${var.project}-primary-vpn"
      drg_id        = var.drg_id
      cpe_key       = "primary-site"
      static_routes = var.primary_on_prem_cidrs
    }

    # DR site VPN
    dr-vpn = {
      display_name  = "${var.project}-dr-vpn"
      drg_id        = var.drg_id
      cpe_key       = "dr-site"
      static_routes = var.dr_on_prem_cidrs
    }
  }

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
