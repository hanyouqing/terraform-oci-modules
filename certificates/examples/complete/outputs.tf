output "ca_ids" {
  description = "Certificate Authority IDs"
  value       = module.certificates.certificate_authority_ids
}

output "ca_names" {
  description = "Certificate Authority names"
  value       = module.certificates.certificate_authority_names
}

output "ca_states" {
  description = "Certificate Authority states"
  value       = module.certificates.certificate_authority_states
}

output "certificate_ids" {
  description = "Certificate IDs"
  value       = module.certificates.certificate_ids
}

output "certificate_names" {
  description = "Certificate names"
  value       = module.certificates.certificate_names
}

output "certificate_states" {
  description = "Certificate states"
  value       = module.certificates.certificate_states
}
