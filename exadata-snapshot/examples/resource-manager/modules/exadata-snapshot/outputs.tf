output "snapshot_ids" {
  description = "OCIDs of the Exadata database snapshots, keyed by the snapshots map."
  value       = { for key, snapshot in oci_database_database_snapshot.this : key => snapshot.id }
}

output "snapshot_states" {
  description = "Lifecycle state of each Exadata database snapshot."
  value       = { for key, snapshot in oci_database_database_snapshot.this : key => snapshot.state }
}
