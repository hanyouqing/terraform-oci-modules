resource "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id   = var.tenancy_ocid
  reporting_region = var.reporting_region
  status           = var.status
}

resource "oci_cloud_guard_target" "this" {
  for_each = var.targets

  compartment_id       = each.value.compartment_id
  display_name         = each.key
  target_resource_id   = each.value.target_resource_id
  target_resource_type = each.value.target_resource_type

  dynamic "target_detector_recipes" {
    for_each = each.value.detector_recipe_ids
    content {
      detector_recipe_id = target_detector_recipes.value
    }
  }

  dynamic "target_responder_recipes" {
    for_each = each.value.responder_recipe_ids
    content {
      responder_recipe_id = target_responder_recipes.value
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags

  depends_on = [oci_cloud_guard_cloud_guard_configuration.this]
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/cloud-guard"
    Project     = var.project
    Environment = var.environment
  }
}
