module "file_storage" {
  source = "./modules/file-storage"

  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.display_name
  subnet_id           = var.subnet_id
  export_source_cidr  = var.export_source_cidr

  project     = "file-storage"
  environment = "development"
}
