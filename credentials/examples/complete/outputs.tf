output "api_key_ids" {
  description = "Map of API key identifiers."
  value       = module.credentials.api_key_ids
}

output "api_key_fingerprints" {
  description = "Map of API key fingerprints."
  value       = module.credentials.api_key_fingerprints
}

output "auth_token_ids" {
  description = "Map of auth token identifiers."
  value       = module.credentials.auth_token_ids
}

output "auth_token_values" {
  description = "Map of auth token values (sensitive)."
  value       = module.credentials.auth_token_values
  sensitive   = true
}

output "customer_secret_key_ids" {
  description = "Map of customer secret key identifiers (access key IDs)."
  value       = module.credentials.customer_secret_key_ids
}

output "customer_secret_key_keys" {
  description = "Map of customer secret key values (sensitive)."
  value       = module.credentials.customer_secret_key_keys
  sensitive   = true
}

output "smtp_credential_ids" {
  description = "Map of SMTP credential identifiers."
  value       = module.credentials.smtp_credential_ids
}

output "smtp_credential_usernames" {
  description = "Map of SMTP usernames."
  value       = module.credentials.smtp_credential_usernames
}

output "smtp_credential_passwords" {
  description = "Map of SMTP passwords (sensitive)."
  value       = module.credentials.smtp_credential_passwords
  sensitive   = true
}

output "reminders" {
  description = "Helpful reminders and next steps."
  value       = module.credentials.zzz_reminders
}
