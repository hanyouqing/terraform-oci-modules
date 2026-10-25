module "cloud_guard" {
  source = "./modules/cloud-guard"

  tenancy_ocid     = var.tenancy_ocid
  reporting_region = var.reporting_region

  project     = "cloud-guard"
  environment = "development"
}
