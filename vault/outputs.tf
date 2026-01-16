output "vault_id" {
  description = "OCID of the vault"
  value       = oci_kms_vault.this.id
}

output "vault_management_endpoint" {
  description = "Management endpoint of the vault"
  value       = oci_kms_vault.this.management_endpoint
}

output "vault_crypto_endpoint" {
  description = "Crypto endpoint of the vault"
  value       = oci_kms_vault.this.crypto_endpoint
}

output "key_ids" {
  description = "OCIDs of the keys"
  value       = { for k, v in oci_kms_key.this : k => v.id }
}

output "secret_ids" {
  description = "OCIDs of the secrets"
  value       = { for k, v in oci_vault_secret.this : k => v.id }
}
