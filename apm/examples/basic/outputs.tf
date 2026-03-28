output "apm_domain_ids" {
  description = "APM domain IDs"
  value       = module.apm.apm_domain_ids
}

output "data_upload_endpoints" {
  description = "Data upload endpoints for APM agents"
  value       = module.apm.apm_domain_data_upload_endpoints
  sensitive   = true
}
