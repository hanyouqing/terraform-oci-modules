resource "oci_generative_ai_dedicated_ai_cluster" "this" {
  compartment_id          = var.compartment_id
  type                    = var.cluster_type
  unit_count              = var.unit_count
  unit_shape              = var.unit_shape
  display_name            = var.display_name
  description             = var.description
  capacity_reservation_id = var.capacity_reservation_id

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/generative-ai"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
