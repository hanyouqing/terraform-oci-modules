module "exadata" {
  source = "./modules/exadata"

  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.display_name
  shape               = var.shape
  compute_count       = var.compute_count
  storage_count       = var.storage_count

  project     = "exadata"
  environment = "development"
}
