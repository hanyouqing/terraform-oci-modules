output "bastion_id" {
  description = "Bastion ID"
  value       = module.bastion.bastion_id
}

output "bastion_name" {
  description = "Bastion name"
  value       = module.bastion.bastion_name
}

output "session_ids" {
  description = "Session IDs"
  value       = module.bastion.session_ids
}
