output "certificate_authority_ids" {
  description = "OCIDs of the Certificate Authorities"
  value       = { for k, v in oci_certificates_management_certificate_authority.this : k => v.id }
}

output "certificate_authority_names" {
  description = "Names of the Certificate Authorities"
  value       = { for k, v in oci_certificates_management_certificate_authority.this : k => v.name }
}

output "certificate_authority_states" {
  description = "Lifecycle states of the Certificate Authorities"
  value       = { for k, v in oci_certificates_management_certificate_authority.this : k => v.state }
}

output "certificate_ids" {
  description = "OCIDs of the certificates"
  value       = { for k, v in oci_certificates_management_certificate.this : k => v.id }
}

output "certificate_names" {
  description = "Names of the certificates"
  value       = { for k, v in oci_certificates_management_certificate.this : k => v.name }
}

output "certificate_states" {
  description = "Lifecycle states of the certificates"
  value       = { for k, v in oci_certificates_management_certificate.this : k => v.state }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Certificates module"
  value = {
    next_steps = [
      "Configure IAM policies: Allow group <group> to manage certificate-authority-family in compartment <compartment>",
      "Attach certificates to Load Balancers or API Gateways for TLS termination",
      "Set up certificate auto-renewal before expiry",
      "Configure Certificate Revocation Lists (CRLs) for production CAs",
      "Review CA hierarchy (root → subordinate) for production PKI"
    ]
    verification = [
      "List CAs: oci certs-mgmt certificate-authority list --compartment-id ${var.compartment_id}",
      "Get CA: oci certs-mgmt certificate-authority get --certificate-authority-id ${length(oci_certificates_management_certificate_authority.this) > 0 ? values(oci_certificates_management_certificate_authority.this)[0].id : "N/A"}",
      "List certs: oci certs-mgmt certificate list --compartment-id ${var.compartment_id}",
      "Get cert: oci certs-mgmt certificate get --certificate-id ${length(oci_certificates_management_certificate.this) > 0 ? values(oci_certificates_management_certificate.this)[0].id : "N/A"}"
    ]
    security_notes = [
      "Protect the KMS key used by CAs — loss means CA becomes unusable",
      "Use subordinate CAs for issuing leaf certificates (keep root CA offline/minimal)",
      "Set maximum validity durations on CAs to enforce certificate rotation",
      "Use TLS_SERVER_OR_CLIENT profile for general-purpose certificates",
      "Enable OCI Audit logging for certificate operations"
    ]
    cost_optimization = [
      "Always Free: 5 CAs + 150 certificates per tenancy",
      "Use software KMS keys (free) for CA key protection",
      "Consolidate certificates under shared CAs to minimize CA count",
      "Use wildcard certificates to reduce total certificate count",
      "Monitor certificate expiry to avoid service disruptions"
    ]
    important_resources = {
      ca_count   = length(oci_certificates_management_certificate_authority.this)
      cert_count = length(oci_certificates_management_certificate.this)
      cas        = { for k, v in oci_certificates_management_certificate_authority.this : k => v.name }
      certs      = { for k, v in oci_certificates_management_certificate.this : k => v.name }
    }
  }
}
