module "security_zones" {
  source = "./modules/security-zones"

  compartment_id          = var.compartment_ocid
  display_name            = var.display_name
  security_zone_recipe_id = var.security_zone_recipe_id
  security_policies       = var.security_policies
  project                 = "security-zones"
  environment             = "basic"
}
