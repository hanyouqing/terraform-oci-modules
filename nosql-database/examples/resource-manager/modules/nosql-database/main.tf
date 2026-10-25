# --- NoSQL Tables ---

resource "oci_nosql_table" "this" {
  for_each = var.tables

  compartment_id = var.compartment_id
  name           = each.value.name
  ddl_statement  = each.value.ddl_statement

  is_auto_reclaimable = each.value.is_auto_reclaimable

  table_limits {
    max_read_units     = each.value.capacity_mode == "ON_DEMAND" ? 0 : each.value.max_read_units
    max_write_units    = each.value.capacity_mode == "ON_DEMAND" ? 0 : each.value.max_write_units
    max_storage_in_gbs = each.value.max_storage_in_gbs
    capacity_mode      = each.value.capacity_mode
  }

  freeform_tags = merge(
    {
      "ManagedBy"  = "terraform"
      "Module"     = "github.com/hanyouqing/terraform-oci-modules/nosql-database"
      "AlwaysFree" = each.value.max_storage_in_gbs <= 25 ? "true" : "false"
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

# --- Secondary Indexes ---

resource "oci_nosql_index" "this" {
  for_each = var.indexes

  table_name_or_id = oci_nosql_table.this[each.value.table_key].id
  name             = each.value.name
  compartment_id   = var.compartment_id
  is_if_not_exists = each.value.is_if_not_exists

  dynamic "keys" {
    for_each = each.value.keys
    content {
      column_name     = keys.value.column_name
      json_field_type = keys.value.json_field_type
      json_path       = keys.value.json_path
    }
  }
}
