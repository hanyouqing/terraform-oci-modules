output "database_ids" {
  description = "Database IDs"
  value       = module.autonomous_database.database_ids
}

output "database_connection_strings" {
  description = "Database connection strings"
  value       = module.autonomous_database.database_connection_strings
  sensitive   = true
}

output "database_connection_urls" {
  description = "Database connection URLs"
  value       = module.autonomous_database.database_connection_urls
  sensitive   = true
}

output "database_private_endpoints" {
  description = "Database private endpoints"
  value       = module.autonomous_database.database_private_endpoints
}

output "database_public_endpoints" {
  description = "Database public endpoints"
  value       = module.autonomous_database.database_public_endpoints
  sensitive   = true
}
