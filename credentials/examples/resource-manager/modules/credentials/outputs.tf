# -----------------------------------------------------------------------------
# API Key Outputs
# -----------------------------------------------------------------------------

output "api_key_ids" {
  description = "Map of API key identifiers."
  value       = { for k, v in oci_identity_api_key.this : k => v.id }
}

output "api_key_fingerprints" {
  description = "Map of API key fingerprints."
  value       = { for k, v in oci_identity_api_key.this : k => v.fingerprint }
}

# -----------------------------------------------------------------------------
# Auth Token Outputs
# -----------------------------------------------------------------------------

output "auth_token_ids" {
  description = "Map of auth token identifiers."
  value       = { for k, v in oci_identity_auth_token.this : k => v.id }
}

output "auth_token_values" {
  description = "Map of auth token values. Only available at creation time."
  value       = { for k, v in oci_identity_auth_token.this : k => v.token }
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Customer Secret Key Outputs
# -----------------------------------------------------------------------------

output "customer_secret_key_ids" {
  description = "Map of customer secret key identifiers (access key IDs)."
  value       = { for k, v in oci_identity_customer_secret_key.this : k => v.id }
}

output "customer_secret_key_keys" {
  description = "Map of customer secret key values. Only available at creation time."
  value       = { for k, v in oci_identity_customer_secret_key.this : k => v.key }
  sensitive   = true
}

# -----------------------------------------------------------------------------
# SMTP Credential Outputs
# -----------------------------------------------------------------------------

output "smtp_credential_ids" {
  description = "Map of SMTP credential identifiers."
  value       = { for k, v in oci_identity_smtp_credential.this : k => v.id }
}

output "smtp_credential_usernames" {
  description = "Map of SMTP usernames."
  value       = { for k, v in oci_identity_smtp_credential.this : k => v.username }
}

output "smtp_credential_passwords" {
  description = "Map of SMTP passwords. Only available at creation time."
  value       = { for k, v in oci_identity_smtp_credential.this : k => v.password }
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Reminders
# -----------------------------------------------------------------------------

output "zzz_reminders" {
  description = "Helpful reminders and next steps for credential management."
  value = {
    next_steps = [
      "1. Store sensitive credential values in a secret manager (e.g., OCI Vault)",
      "2. Use `terraform output -json` to retrieve sensitive values after creation",
      "3. Rotate credentials regularly (recommended: every 90 days)",
      "4. Configure your OCI CLI config file with API key fingerprints",
    ]
    security_notes = [
      "API keys: Max 3 per user. Never commit private keys to source control",
      "Auth tokens: Max 2 per user. Token value is only shown at creation time",
      "Customer secret keys: Max 2 per user. Secret key is only shown at creation time",
      "SMTP credentials: Max 2 per user. Password is only shown at creation time",
      "All credential secrets are marked as sensitive in Terraform state",
    ]
    cost_optimization = [
      "All IAM credentials are Always Free — no charges apply",
      "Delete unused credentials to stay within per-user limits",
    ]
    usage_tips = [
      "Retrieve secrets: terraform output -json smtp_credential_passwords",
      "List API key fingerprints: terraform output -json api_key_fingerprints",
      "S3-compatible access: use customer_secret_key_ids as Access Key, customer_secret_key_keys as Secret Key",
      "SMTP config: use smtp_credential_usernames and smtp_credential_passwords with OCI SMTP endpoint",
    ]
  }
}
