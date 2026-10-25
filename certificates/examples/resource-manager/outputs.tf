output "vault_id" {
  description = "Vault ID (for KMS key)"
  value       = module.vault.vault_id
}

output "ca_ids" {
  description = "Certificate Authority IDs"
  value       = module.certificates.certificate_authority_ids
}

output "ca_names" {
  description = "Certificate Authority names"
  value       = module.certificates.certificate_authority_names
}
