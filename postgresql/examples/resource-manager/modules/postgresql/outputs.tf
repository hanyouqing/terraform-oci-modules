output "db_system_id" {
  description = "OCID of the PostgreSQL database system."
  value       = oci_psql_db_system.this.id
}

output "state" {
  description = "Lifecycle state of the PostgreSQL database system."
  value       = oci_psql_db_system.this.state
}

output "admin_username" {
  description = "Administrator username reported by the database system."
  value       = oci_psql_db_system.this.admin_username
}
