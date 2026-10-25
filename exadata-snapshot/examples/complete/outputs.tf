output "snapshot_ids" {
  description = "OCIDs of the database snapshots."
  value       = module.database_snapshot.snapshot_ids
}

output "snapshot_states" {
  description = "Lifecycle state of each database snapshot."
  value       = module.database_snapshot.snapshot_states
}
