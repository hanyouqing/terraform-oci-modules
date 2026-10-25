module "cache" {
  source = "./modules/cache"

  compartment_id     = var.compartment_ocid
  display_name       = var.display_name
  subnet_id          = var.subnet_id
  software_version   = var.software_version
  node_count         = var.node_count
  node_memory_in_gbs = var.node_memory_in_gbs

  project     = "cache"
  environment = "development"
}
