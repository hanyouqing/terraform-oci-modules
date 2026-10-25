module "vpn" {
  source = "./modules/site-to-site-vpn"

  compartment_id = var.compartment_ocid

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
