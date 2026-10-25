module "data_safe" {
  source = "./modules/data-safe"

  tenancy_ocid = var.tenancy_ocid
  is_enabled   = true

  project     = "data-safe"
  environment = "development"
}
