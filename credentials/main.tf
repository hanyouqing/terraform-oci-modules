# -----------------------------------------------------------------------------
# API Keys
# -----------------------------------------------------------------------------

resource "oci_identity_api_key" "this" {
  for_each = var.api_keys

  user_id   = var.user_id
  key_value = each.value.key_value
}

# -----------------------------------------------------------------------------
# Auth Tokens
# -----------------------------------------------------------------------------

resource "oci_identity_auth_token" "this" {
  for_each = var.auth_tokens

  user_id     = var.user_id
  description = each.value.description
}

# -----------------------------------------------------------------------------
# Customer Secret Keys (S3-Compatible)
# -----------------------------------------------------------------------------

resource "oci_identity_customer_secret_key" "this" {
  for_each = var.customer_secret_keys

  user_id      = var.user_id
  display_name = each.value.display_name
}

# -----------------------------------------------------------------------------
# SMTP Credentials
# -----------------------------------------------------------------------------

resource "oci_identity_smtp_credential" "this" {
  for_each = var.smtp_credentials

  user_id     = var.user_id
  description = each.value.description
}
