output "table_ids" {
  description = "OCIDs of the NoSQL tables"
  value       = { for k, v in oci_nosql_table.this : k => v.id }
}

output "table_names" {
  description = "Names of the NoSQL tables"
  value       = { for k, v in oci_nosql_table.this : k => v.name }
}

output "table_states" {
  description = "Lifecycle states of the NoSQL tables"
  value       = { for k, v in oci_nosql_table.this : k => v.lifecycle_state }
}

output "table_schemas" {
  description = "Schemas of the NoSQL tables"
  value       = { for k, v in oci_nosql_table.this : k => v.schema }
}

output "table_limits" {
  description = "Table limits (read/write units, storage) for each table"
  value = {
    for k, v in oci_nosql_table.this : k => {
      max_read_units     = v.table_limits[0].max_read_units
      max_write_units    = v.table_limits[0].max_write_units
      max_storage_in_gbs = v.table_limits[0].max_storage_in_gbs
      capacity_mode      = v.table_limits[0].capacity_mode
    }
  }
}

output "index_ids" {
  description = "Names and states of the NoSQL indexes"
  value = {
    for k, v in oci_nosql_index.this : k => {
      name  = v.name
      state = v.state
    }
  }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for NoSQL Database module"
  value = {
    next_steps = [
      "Insert data using OCI SDKs (Java, Python, Go, Node.js) or the NoSQL Console",
      "Configure IAM policies for table access: Allow group <group> to manage nosql-tables in compartment <compartment>",
      "Set up monitoring alarms for read/write throttling",
      "Review table limits and adjust for production workloads",
      "Enable auto-reclaimable for dev/test tables to reclaim idle resources"
    ]
    verification = [
      "List tables: oci nosql table list --compartment-id ${var.compartment_id}",
      "Get table: oci nosql table get --table-name-or-id ${length(oci_nosql_table.this) > 0 ? values(oci_nosql_table.this)[0].id : "N/A"}",
      "Query data: oci nosql query execute --compartment-id ${var.compartment_id} --statement \"SELECT * FROM <table_name> LIMIT 10\""
    ]
    security_notes = [
      "Use IAM policies to restrict table access by compartment and group",
      "Enable OCI Audit logging for NoSQL operations",
      "Use defined tags for governance and cost tracking",
      "Avoid storing sensitive data without encryption at the application level"
    ]
    cost_optimization = [
      "Always Free: 3 tables, 25 GB/table, 133M read units + 133M write units/month",
      "Use PROVISIONED mode for predictable workloads, ON_DEMAND for variable workloads",
      "Right-size read/write units to match actual usage patterns",
      "Enable is_auto_reclaimable for dev/test tables",
      "Monitor throttling metrics to detect over/under-provisioning"
    ]
    important_resources = {
      table_count = length(oci_nosql_table.this)
      index_count = length(oci_nosql_index.this)
      tables      = { for k, v in oci_nosql_table.this : k => v.name }
    }
  }
}
