module "functions" {
  source = "./modules/functions"

  compartment_id = var.compartment_ocid
  display_name   = var.display_name
  subnet_ids     = var.subnet_ids
  shape          = var.shape
  functions      = var.functions
  project        = "functions"
  environment    = "basic"
}
