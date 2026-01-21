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

output "zzz_reminders" {
  description = "Important reminders and next steps for Vault module"
  value = {
    next_steps = [
      "Verify keys are created and accessible",
      "Test encryption/decryption operations",
      "Review secret access policies and IAM permissions",
      "Set up key rotation policies if needed",
      "Configure backup for keys and secrets"
    ]
    verification = [
      "List vaults: oci kms management vault list --compartment-id ${var.compartment_id}",
      "Check vault state: oci kms management vault get --vault-id ${oci_kms_vault.this.id}",
      "List keys: oci kms management key list --compartment-id ${var.compartment_id} --endpoint ${oci_kms_vault.this.management_endpoint}",
      "List secrets: oci vault secret list --compartment-id ${var.compartment_id} --vault-id ${oci_kms_vault.this.id}"
    ]
    security_notes = [
      "Use Default Vault with software keys for cost savings (free)",
      "Use Virtual Private Vault only when HSM keys are required",
      "Rotate keys regularly for security best practices",
      "Use IAM policies for fine-grained access control",
      "Enable audit logging for key and secret access"
    ]
    cost_optimization = [
      "Always Free tier: Unlimited software keys, 150 secrets",
      "Use Default Vault with software keys (free)",
      "Use Virtual Private Vault only when HSM is required (~$200-250/month)",
      "Consolidate secrets to stay within Always Free tier (150 secrets)",
      "Monitor key operations to optimize HSM usage costs"
    ]
    important_resources = {
      vault_id            = oci_kms_vault.this.id
      vault_type          = oci_kms_vault.this.vault_type
      key_count           = length(oci_kms_key.this)
      secret_count        = length(oci_vault_secret.this)
      management_endpoint = oci_kms_vault.this.management_endpoint
      crypto_endpoint     = oci_kms_vault.this.crypto_endpoint
    }
    usage_tips = [
      "Use management endpoint for key management operations",
      "Use crypto endpoint for encryption/decryption operations",
      "Store secrets securely and rotate regularly",
      "Use key versions for key rotation without service interruption"
    ]
  }
}
