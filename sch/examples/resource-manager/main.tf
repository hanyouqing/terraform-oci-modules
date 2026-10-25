module "sch" {
  source = "./modules/sch"

  compartment_id = var.compartment_ocid
  connectors     = var.connectors
  project        = "sch"
  environment    = "basic"
}
