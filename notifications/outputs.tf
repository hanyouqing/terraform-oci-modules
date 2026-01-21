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

output "zzz_reminders" {
  description = "Important reminders and next steps for Notifications module"
  value = {
    next_steps = [
      "Test notification delivery to verify subscriptions work",
      "Configure IAM policies for topic publishing",
      "Set up multiple subscriptions for redundancy",
      "Review and update subscription endpoints as needed",
      "Monitor notification delivery success rates"
    ]
    verification = [
      "List topics: oci ons topic list --compartment-id ${var.compartment_id}",
      "Check topic details: oci ons topic get --topic-id ${length(oci_ons_notification_topic.this) > 0 ? values(oci_ons_notification_topic.this)[0].id : "N/A"}",
      "List subscriptions: oci ons subscription list --compartment-id ${var.compartment_id}",
      "Test publish: oci ons topic publish --topic-id ${length(oci_ons_notification_topic.this) > 0 ? values(oci_ons_notification_topic.this)[0].id : "N/A"} --body 'Test message'"
    ]
    security_notes = [
      "Use HTTPS subscriptions for secure delivery",
      "Validate subscription endpoints are legitimate",
      "Use IAM policies to restrict topic publishing",
      "Monitor notification access and delivery",
      "Use email subscriptions sparingly (lower free tier)"
    ]
    cost_optimization = [
      "Always Free tier: 1M HTTPS + 1K email notifications",
      "Use HTTPS subscriptions when possible (higher free tier)",
      "Optimize notification frequency to reduce volume",
      "Batch notifications to reduce per-notification overhead",
      "Monitor notification usage to stay within Always Free tier"
    ]
    important_resources = {
      topic_count        = length(oci_ons_notification_topic.this)
      subscription_count = length(oci_ons_subscription.this)
    }
    usage_tips = [
      "Use topics for event-driven architectures",
      "Subscribe monitoring alarms to topics for alerting",
      "Use HTTPS endpoints for webhook integrations",
      "Test subscriptions regularly to ensure they work",
      "Use multiple subscriptions for redundancy"
    ]
  }
}
