output "mysql_system_ids" {
  description = "OCIDs of the MySQL systems"
  value       = { for k, v in oci_mysql_mysql_db_system.this : k => v.id }
}

output "mysql_endpoints" {
  description = "Endpoints of the MySQL systems"
  value       = { for k, v in oci_mysql_mysql_db_system.this : k => v.endpoints }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for MySQL module"
  value = {
    next_steps = [
      "Connect to MySQL using: mysql -h <endpoint> -u admin -p",
      "Change default admin password after first login",
      "Configure database users and access controls",
      "Review and configure backup policies",
      "Set up monitoring and alerting for database health"
    ]
    verification = [
      "List MySQL systems: oci mysql db-system list --compartment-id ${var.compartment_id}",
      "Check system state: oci mysql db-system get --db-system-id ${length(oci_mysql_mysql_db_system.this) > 0 ? values(oci_mysql_mysql_db_system.this)[0].id : "N/A"}",
      "View endpoints: oci mysql db-system get --db-system-id ${length(oci_mysql_mysql_db_system.this) > 0 ? values(oci_mysql_mysql_db_system.this)[0].id : "N/A"} --query 'data.endpoints'"
    ]
    security_notes = [
      "Use strong admin passwords and rotate regularly",
      "Enable SSL/TLS for database connections",
      "Restrict network access using security lists or NSGs",
      "Use private subnets for database instances",
      "Enable audit logging for compliance"
    ]
    cost_optimization = [
      "Always Free tier: 1 single-node system, 50 GB data + 50 GB backup",
      "Right-size storage to match actual data needs",
      "Optimize backup retention to balance recovery needs with costs",
      "Monitor instance utilization and scale down when possible"
    ]
    important_resources = {
      system_count    = length(oci_mysql_mysql_db_system.this)
      data_storage_gb = length(oci_mysql_mysql_db_system.this) > 0 ? values(oci_mysql_mysql_db_system.this)[0].data_storage_size_in_gb : 0
      mysql_version   = length(oci_mysql_mysql_db_system.this) > 0 ? values(oci_mysql_mysql_db_system.this)[0].mysql_version : "N/A"
    }
    connection_info = length(oci_mysql_mysql_db_system.this) > 0 && length(values(oci_mysql_mysql_db_system.this)[0].endpoints) > 0 ? {
      hostname      = values(oci_mysql_mysql_db_system.this)[0].endpoints[0].hostname
      port          = values(oci_mysql_mysql_db_system.this)[0].endpoints[0].port
      mysql_command = "mysql -h ${values(oci_mysql_mysql_db_system.this)[0].endpoints[0].hostname} -P ${values(oci_mysql_mysql_db_system.this)[0].endpoints[0].port} -u admin -p"
    } : null
  }
}
