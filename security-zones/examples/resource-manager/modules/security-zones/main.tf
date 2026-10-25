resource "oci_cloud_guard_security_recipe" "this" {
  count = var.security_zone_recipe_id == null ? 1 : 0

  compartment_id    = var.compartment_id
  display_name      = coalesce(var.recipe_display_name, "${var.display_name}-recipe")
  description       = var.recipe_description
  security_policies = var.security_policies

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_cloud_guard_security_zone" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  description    = var.description
  security_zone_recipe_id = coalesce(
    var.security_zone_recipe_id,
    try(oci_cloud_guard_security_recipe.this[0].id, null)
  )

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/security-zones"
    Project     = var.project
    Environment = var.environment
  }
}
