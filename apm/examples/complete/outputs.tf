output "apm_domain_ids" {
  description = "APM domain IDs"
  value       = module.apm.apm_domain_ids
}

output "data_upload_endpoints" {
  description = "Data upload endpoints for APM agents"
  value       = module.apm.apm_domain_data_upload_endpoints
  sensitive   = true
}

output "apm_domain_states" {
  description = "APM domain states"
  value       = module.apm.apm_domain_states
}

output "monitor_ids" {
  description = "Synthetics monitor IDs"
  value       = module.apm.synthetics_monitor_ids
}

output "monitor_statuses" {
  description = "Synthetics monitor statuses"
  value       = module.apm.synthetics_monitor_statuses
}
