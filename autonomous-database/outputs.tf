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
  value = {
    for k, v in oci_database_autonomous_database.this : k => length(v.connection_strings) > 0 && length(v.connection_strings[0].profiles) > 0 ? v.connection_strings[0].profiles[0].value : null
  }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Autonomous Database module"
  value = {
    next_steps = [
      "Download wallet files for secure database connections",
      "Configure network access (whitelist IPs or use private endpoints)",
      "Set up database users and configure access controls",
      "Enable auto-scaling if workload is variable",
      "Review and configure backup retention policies"
    ]
    verification = [
      "List databases: oci db autonomous-database list --compartment-id ${var.compartment_id}",
      "Check database state: oci db autonomous-database get --autonomous-database-id ${length(oci_database_autonomous_database.this) > 0 ? values(oci_database_autonomous_database.this)[0].id : "N/A"}",
      "Download wallet: oci db autonomous-database generate-wallet --autonomous-database-id ${length(oci_database_autonomous_database.this) > 0 ? values(oci_database_autonomous_database.this)[0].id : "N/A"} --file wallet.zip --password <password>"
    ]
    security_notes = [
      "Use strong admin passwords and rotate regularly",
      "Enable mTLS for secure connections",
      "Use private endpoints for production workloads",
      "Restrict network access using whitelist IPs or NSGs",
      "Enable audit logging for compliance"
    ]
    cost_optimization = [
      "Always Free tier: 2 instances, 1 OCPU + 20 GB each",
      "Use Shared infrastructure for cost-effective scaling",
      "Enable auto-scaling to optimize costs based on workload",
      "Right-size storage to match actual data needs",
      "Monitor resource usage and adjust as needed"
    ]
    important_resources = {
      database_count = length(oci_database_autonomous_database.this)
      is_free_tier   = length(oci_database_autonomous_database.this) > 0 ? values(oci_database_autonomous_database.this)[0].is_free_tier : false
      workload_type  = length(oci_database_autonomous_database.this) > 0 ? values(oci_database_autonomous_database.this)[0].db_workload : "N/A"
    }
    connection_info = length(oci_database_autonomous_database.this) > 0 ? {
      connection_string   = values(oci_database_autonomous_database.this)[0].connection_strings[0].profiles[0].value
      service_console_url = values(oci_database_autonomous_database.this)[0].service_console_url
    } : null
  }
}
