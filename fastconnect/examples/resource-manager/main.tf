module "fastconnect" {
  source = "./modules/fastconnect"

  compartment_id       = var.compartment_ocid
  display_name         = var.display_name
  bandwidth_shape_name = var.bandwidth_shape_name
  customer_bgp_asn     = var.customer_bgp_asn
  gateway_id           = var.gateway_id
  provider_service_id  = var.provider_service_id

  project     = "fastconnect"
  environment = "development"
}
