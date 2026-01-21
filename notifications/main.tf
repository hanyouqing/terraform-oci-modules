resource "oci_ons_notification_topic" "this" {
  for_each = var.topics

  compartment_id = var.compartment_id
  name           = each.value.name
  description    = each.value.description

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/notifications"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
}

resource "oci_ons_subscription" "this" {
  for_each = var.subscriptions

  compartment_id = var.compartment_id
  topic_id       = oci_ons_notification_topic.this[each.value.topic_key].id
  protocol       = each.value.protocol
  endpoint       = each.value.endpoint

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/notifications/subscription"
    }
  )
}
