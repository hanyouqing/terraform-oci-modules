output "mysql_system_ids" {
  description = "OCIDs of the MySQL systems"
  value       = { for k, v in oci_mysql_mysql_db_system.this : k => v.id }
}

output "mysql_endpoints" {
  description = "Endpoints of the MySQL systems"
  value       = { for k, v in oci_mysql_mysql_db_system.this : k => v.endpoints }
}
