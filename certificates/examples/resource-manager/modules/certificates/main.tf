# --- Certificate Authorities ---

resource "oci_certificates_management_certificate_authority" "this" {
  for_each = var.certificate_authorities

  compartment_id = var.compartment_id
  name           = each.value.name
  description    = each.value.description
  kms_key_id     = each.value.kms_key_id

  certificate_authority_config {
    config_type       = each.value.config_type
    signing_algorithm = each.value.signing_algorithm
    version_name      = each.value.version_name

    issuer_certificate_authority_id = each.value.config_type == "SUBORDINATE_CA_ISSUED_BY_INTERNAL_CA" ? each.value.issuer_certificate_authority_id : null

    subject {
      common_name            = each.value.common_name
      country                = each.value.country
      organization           = each.value.organization
      organizational_unit    = each.value.organizational_unit
      state_or_province_name = each.value.state_name
      locality_name          = each.value.locality
    }

    dynamic "validity" {
      for_each = each.value.time_of_validity_not_after != null ? [1] : []
      content {
        time_of_validity_not_before = each.value.time_of_validity_not_before
        time_of_validity_not_after  = each.value.time_of_validity_not_after
      }
    }
  }

  dynamic "certificate_authority_rules" {
    for_each = each.value.certificate_authority_max_validity_duration != null || each.value.leaf_certificate_max_validity_duration != null ? [1] : []
    content {
      rule_type                                   = "CERTIFICATE_AUTHORITY_ISSUANCE_EXPIRY_RULE"
      certificate_authority_max_validity_duration = each.value.certificate_authority_max_validity_duration
      leaf_certificate_max_validity_duration      = each.value.leaf_certificate_max_validity_duration
    }
  }

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/certificates"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

# --- Certificates ---

resource "oci_certificates_management_certificate" "this" {
  for_each = var.certificates

  compartment_id = var.compartment_id
  name           = each.value.name
  description    = each.value.description

  certificate_config {
    config_type              = each.value.config_type
    certificate_profile_type = each.value.certificate_profile_type
    key_algorithm            = each.value.key_algorithm
    signature_algorithm      = each.value.signature_algorithm

    issuer_certificate_authority_id = each.value.ca_key != null ? oci_certificates_management_certificate_authority.this[each.value.ca_key].id : each.value.issuer_certificate_authority_id

    subject {
      common_name            = each.value.common_name
      country                = each.value.country
      organization           = each.value.organization
      organizational_unit    = each.value.organizational_unit
      state_or_province_name = each.value.state_name
      locality_name          = each.value.locality
    }

    dynamic "subject_alternative_names" {
      for_each = each.value.subject_alternative_names
      content {
        type  = subject_alternative_names.value.type
        value = subject_alternative_names.value.value
      }
    }

    dynamic "validity" {
      for_each = each.value.time_of_validity_not_after != null ? [1] : []
      content {
        time_of_validity_not_before = each.value.time_of_validity_not_before
        time_of_validity_not_after  = each.value.time_of_validity_not_after
      }
    }
  }

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/certificates"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}
