
output "private_endpoint_id" {
  description = "OCID of the Data Safe private endpoint."
  value       = module.data_safe.private_endpoint_id
}

output "target_database_ids" {
  description = "Registered target OCIDs keyed by name."
  value       = module.data_safe.target_database_ids
}
