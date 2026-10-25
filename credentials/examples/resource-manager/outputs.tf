output "auth_token_ids" {
  description = "Map of auth token identifiers."
  value       = module.credentials.auth_token_ids
}

output "auth_token_values" {
  description = "Map of auth token values (sensitive)."
  value       = module.credentials.auth_token_values
  sensitive   = true
}

output "reminders" {
  description = "Helpful reminders and next steps."
  value       = module.credentials.zzz_reminders
}
