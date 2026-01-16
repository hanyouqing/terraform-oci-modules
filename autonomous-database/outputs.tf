output "database_ids" {
  description = "OCIDs of the Autonomous Databases"
  value       = { for k, v in oci_database_autonomous_database.this : k => v.id }
}

output "database_connection_strings" {
  description = "Connection strings for the Autonomous Databases"
  value       = { for k, v in oci_database_autonomous_database.this : k => v.connection_strings }
}

output "database_connection_urls" {
  description = "Connection URLs for the Autonomous Databases"
  value       = { for k, v in oci_database_autonomous_database.this : k => v.connection_urls }
}

output "database_private_endpoints" {
  description = "Private endpoints for the Autonomous Databases"
  value       = { for k, v in oci_database_autonomous_database.this : k => v.private_endpoint }
}

output "database_public_endpoints" {
  description = "Public endpoints for the Autonomous Databases"
  value       = { for k, v in oci_database_autonomous_database.this : k => v.connection_strings[0].profiles[0].value }
}
