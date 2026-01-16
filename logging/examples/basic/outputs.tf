output "log_group_ids" {
  description = "Log group IDs"
  value       = module.logging.log_group_ids
}

output "log_ids" {
  description = "Log IDs"
  value       = module.logging.log_ids
}
