output "table_ids" {
  description = "NoSQL table IDs"
  value       = module.nosql_database.table_ids
}

output "table_names" {
  description = "NoSQL table names"
  value       = module.nosql_database.table_names
}

output "table_states" {
  description = "NoSQL table lifecycle states"
  value       = module.nosql_database.table_states
}

output "table_limits" {
  description = "NoSQL table limits"
  value       = module.nosql_database.table_limits
}

output "index_ids" {
  description = "NoSQL index details"
  value       = module.nosql_database.index_ids
}
