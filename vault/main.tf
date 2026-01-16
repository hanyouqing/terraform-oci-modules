terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

resource "oci_kms_vault" "this" {
  compartment_id   = var.compartment_id
  display_name     = var.vault_display_name
  vault_type       = var.vault_type
  freeform_tags    = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/vault"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
  defined_tags     = var.defined_tags
}

resource "oci_kms_key" "this" {
  for_each = var.keys

  compartment_id      = var.compartment_id
  display_name        = each.value.display_name
  management_endpoint = oci_kms_vault.this.management_endpoint
  key_shape {
    algorithm = each.value.algorithm
    length    = each.value.length != null ? each.value.length : null
    curve_id  = each.value.curve_id != null ? each.value.curve_id : null
  }
  protection_mode = each.value.protection_mode

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vault/key"
    }
  )
}

resource "oci_vault_secret" "this" {
  for_each = var.secrets

  compartment_id = var.compartment_id
  secret_content {
    content      = each.value.secret_content
    content_type = each.value.content_type
  }
  vault_id    = oci_kms_vault.this.id
  display_name = each.value.display_name
  key_id      = each.value.key_id

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vault/secret"
    }
  )
}
