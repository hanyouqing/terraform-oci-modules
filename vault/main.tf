resource "oci_kms_vault" "this" {
  compartment_id = var.compartment_id
  display_name   = var.vault_display_name
  vault_type     = var.vault_type
  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/vault"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
  defined_tags = var.defined_tags
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
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vault/key"
    }
  )
}

resource "oci_vault_secret" "this" {
  for_each = toset(nonsensitive(keys(var.secrets)))

  compartment_id = var.compartment_id
  secret_content {
    content      = var.secrets[each.key].secret_content
    content_type = var.secrets[each.key].content_type
  }
  vault_id    = oci_kms_vault.this.id
  secret_name = var.secrets[each.key].secret_name
  key_id      = var.secrets[each.key].key_id

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vault/secret"
    }
  )
}
