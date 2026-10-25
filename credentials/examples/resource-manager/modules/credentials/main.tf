# Identity credential resources (API keys, auth tokens, customer secret keys,
# SMTP credentials) do not support freeform_tags or defined_tags in OCI.

locals {
  user_id_valid = var.user_id != null && var.user_id != "" && can(regex("^ocid1\\.user\\.", var.user_id))
}

# -----------------------------------------------------------------------------
# API Keys
# -----------------------------------------------------------------------------

resource "oci_identity_api_key" "this" {
  for_each = toset(nonsensitive(keys(var.api_keys)))

  user_id   = var.user_id
  key_value = var.api_keys[each.key].key_value

  lifecycle {
    precondition {
      condition     = local.user_id_valid
      error_message = "user_id must be a valid OCI user OCID when creating API keys."
    }
  }
}

# -----------------------------------------------------------------------------
# Auth Tokens
# -----------------------------------------------------------------------------

resource "oci_identity_auth_token" "this" {
  for_each = var.auth_tokens

  user_id     = var.user_id
  description = each.value.description

  lifecycle {
    precondition {
      condition     = local.user_id_valid
      error_message = "user_id must be a valid OCI user OCID when creating auth tokens."
    }
  }
}

# -----------------------------------------------------------------------------
# Customer Secret Keys (S3-Compatible)
# -----------------------------------------------------------------------------

resource "oci_identity_customer_secret_key" "this" {
  for_each = var.customer_secret_keys

  user_id      = var.user_id
  display_name = each.value.display_name

  lifecycle {
    precondition {
      condition     = local.user_id_valid
      error_message = "user_id must be a valid OCI user OCID when creating customer secret keys."
    }
  }
}

# -----------------------------------------------------------------------------
# SMTP Credentials
# -----------------------------------------------------------------------------

resource "oci_identity_smtp_credential" "this" {
  for_each = var.smtp_credentials

  user_id     = var.user_id
  description = each.value.description

  lifecycle {
    precondition {
      condition     = local.user_id_valid
      error_message = "user_id must be a valid OCI user OCID when creating SMTP credentials."
    }
  }
}
