module "fsdr" {
  source = "./modules/fsdr"

  compartment_id = var.compartment_ocid
  display_name   = var.display_name
  log_bucket     = var.log_bucket
  log_namespace  = var.log_namespace
  association    = var.association
  members        = var.members
  project        = "fsdr"
  environment    = "basic"
}
