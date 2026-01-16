output "vault_id" {
  description = "Vault ID"
  value       = module.vault.vault_id
}

output "vault_management_endpoint" {
  description = "Vault management endpoint"
  value       = module.vault.vault_management_endpoint
}

output "vault_crypto_endpoint" {
  description = "Vault crypto endpoint"
  value       = module.vault.vault_crypto_endpoint
}

output "key_ids" {
  description = "Key IDs"
  value       = module.vault.key_ids
}

output "secret_ids" {
  description = "Secret IDs"
  value       = module.vault.secret_ids
  sensitive   = true
}
