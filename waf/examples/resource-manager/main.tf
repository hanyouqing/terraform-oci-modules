module "waf" {
  source = "./modules/waf"

  compartment_id = var.compartment_ocid
  display_name   = var.display_name

  project     = "waf"
  environment = "development"
}
