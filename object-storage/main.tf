data "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "this" {
  for_each = var.buckets

  compartment_id = var.compartment_id
  namespace      = each.value.namespace != null ? each.value.namespace : data.oci_objectstorage_namespace.this.namespace
  name           = each.value.name
  access_type    = each.value.access_type
  storage_tier   = each.value.storage_tier
  versioning     = each.value.versioning

  freeform_tags = merge(
    var.freeform_tags,
    each.value.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/object-storage"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

resource "oci_objectstorage_object_lifecycle_policy" "this" {
  for_each = var.lifecycle_policies

  namespace = oci_objectstorage_bucket.this[each.value.bucket_key].namespace
  bucket    = oci_objectstorage_bucket.this[each.value.bucket_key].name

  dynamic "rules" {
    for_each = [each.value]
    content {
      name       = rules.value.rule_name
      is_enabled = rules.value.is_enabled
      action     = rules.value.action
      object_name_filter {
        inclusion_prefixes = length(rules.value.inclusion_prefixes) > 0 ? rules.value.inclusion_prefixes : null
        inclusion_patterns = length(rules.value.inclusion_patterns) > 0 ? rules.value.inclusion_patterns : null
      }
      target      = rules.value.target
      time_amount = rules.value.time_amount
      time_unit   = rules.value.time_unit
    }
  }
}

resource "oci_objectstorage_preauthrequest" "this" {
  for_each = var.preauth_requests

  namespace    = oci_objectstorage_bucket.this[each.value.bucket_key].namespace
  bucket       = oci_objectstorage_bucket.this[each.value.bucket_key].name
  name         = each.value.name
  object       = each.value.object
  access_type  = each.value.access_type
  time_expires = each.value.time_expires
}
