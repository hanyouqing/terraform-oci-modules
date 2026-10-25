module "child_tenancy" {
  source = "./modules/child-tenancy"

  compartment_id = var.tenancy_id
  tenancy_name   = var.tenancy_name
  home_region    = var.home_region
  admin_email    = var.admin_email
}
