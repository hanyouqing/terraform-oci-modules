resource "oci_database_database_snapshot" "this" {
  for_each = var.snapshots

  database_id = var.database_id
  name        = each.value.name

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/exadata-snapshot"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(var.defined_tags, each.value.defined_tags)
}
