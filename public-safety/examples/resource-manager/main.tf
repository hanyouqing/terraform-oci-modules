module "public_safety" {
  source = "./modules/public-safety"

  compartment_id                = var.compartment_ocid
  identity_domain_url           = var.identity_domain_url
  admin_identity_domain_user_id = var.admin_identity_domain_user_id
  display_name                  = var.display_name

  project     = "public-safety"
  environment = "development"
}
