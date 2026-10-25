output "connector_ids" {
  description = "Service connector OCIDs keyed by display name."
  value       = { for name, c in oci_sch_service_connector.this : name => c.id }
}
