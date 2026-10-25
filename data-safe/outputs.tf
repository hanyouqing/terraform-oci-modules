output "is_enabled" {
  description = "Whether Data Safe is enabled for the tenancy."
  value       = oci_data_safe_data_safe_configuration.this.is_enabled
}

output "private_endpoint_id" {
  description = "OCID of the Data Safe private endpoint. Null when private_endpoint is not set."
  value       = try(oci_data_safe_data_safe_private_endpoint.this[0].id, null)
}

output "target_database_ids" {
  description = "OCIDs of registered target databases, keyed by display name."
  value       = { for name, target in oci_data_safe_target_database.this : name => target.id }
}
