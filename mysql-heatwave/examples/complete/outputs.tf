output "mysql_system_ids" {
  description = "MySQL system IDs"
  value       = module.mysql.mysql_system_ids
}

output "mysql_endpoints" {
  description = "MySQL endpoints"
  value       = module.mysql.mysql_endpoints
}
