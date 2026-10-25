output "snapshot_ids" {
  description = "OCIDs of the database snapshots."
  value       = module.database_snapshot.snapshot_ids
}
