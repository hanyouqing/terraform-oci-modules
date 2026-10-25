output "database_ids" {
  description = "Database IDs"
  value       = module.autonomous_database.database_ids
}

output "database_connection_strings" {
  description = "Database connection strings"
  value       = module.autonomous_database.database_connection_strings
  sensitive   = true
}
