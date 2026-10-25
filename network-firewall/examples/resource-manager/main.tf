module "network_firewall" {
  source = "./modules/network-firewall"

  compartment_id      = var.compartment_ocid
  display_name        = var.display_name
  subnet_id           = var.subnet_id
  availability_domain = var.availability_domain
  nsg_ids             = var.nsg_ids
  project             = "network-firewall"
  environment         = "basic"
}
