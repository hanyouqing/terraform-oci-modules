module "oke" {
  source = "./modules/oke"

  compartment_id     = var.compartment_ocid
  name               = var.name
  kubernetes_version = var.kubernetes_version
  vcn_id             = var.vcn_id
  endpoint_subnet_id = var.endpoint_subnet_id

  project     = "oke"
  environment = "development"
}
