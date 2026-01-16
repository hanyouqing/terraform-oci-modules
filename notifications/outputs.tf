output "topic_ids" {
  description = "OCIDs of the notification topics"
  value       = { for k, v in oci_ons_notification_topic.this : k => v.id }
}

output "topic_endpoints" {
  description = "Endpoints of the notification topics"
  value       = { for k, v in oci_ons_notification_topic.this : k => v.topic_id }
}

output "subscription_ids" {
  description = "OCIDs of the subscriptions"
  value       = { for k, v in oci_ons_subscription.this : k => v.id }
}
