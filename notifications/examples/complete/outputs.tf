output "topic_ids" {
  description = "Topic IDs"
  value       = module.notifications.topic_ids
}

output "topic_endpoints" {
  description = "Topic endpoints"
  value       = module.notifications.topic_endpoints
}

output "subscription_ids" {
  description = "Subscription IDs"
  value       = module.notifications.subscription_ids
}
