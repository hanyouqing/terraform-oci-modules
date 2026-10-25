terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "security_zones" {
  source = "../../"

  compartment_id          = var.compartment_id
  display_name            = var.display_name
  security_zone_recipe_id = var.security_zone_recipe_id
  security_policies       = var.security_policies
  project                 = "security-zones"
  environment             = "basic"
}
