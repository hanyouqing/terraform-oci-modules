output "sender_ids" {
  description = "Sender IDs"
  value       = module.email_delivery.sender_ids
}

output "suppression_ids" {
  description = "Suppression IDs"
  value       = module.email_delivery.suppression_ids
}
