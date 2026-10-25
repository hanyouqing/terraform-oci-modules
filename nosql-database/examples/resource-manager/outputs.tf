output "table_ids" {
  description = "NoSQL table IDs"
  value       = module.nosql_database.table_ids
}

output "table_names" {
  description = "NoSQL table names"
  value       = module.nosql_database.table_names
}
