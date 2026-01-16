output "volume_ids" {
  description = "OCIDs of the block volumes"
  value       = { for k, v in oci_core_volume.this : k => v.id }
}

output "volume_display_names" {
  description = "Display names of the block volumes"
  value       = { for k, v in oci_core_volume.this : k => v.display_name }
}

output "volume_sizes" {
  description = "Sizes of the block volumes in GBs"
  value       = { for k, v in oci_core_volume.this : k => v.size_in_gbs }
}

output "backup_ids" {
  description = "OCIDs of the volume backups"
  value       = { for k, v in oci_core_volume_backup.this : k => v.id }
}

output "backup_policy_ids" {
  description = "OCIDs of the backup policies"
  value       = { for k, v in oci_core_volume_backup_policy.this : k => v.id }
}

output "attachment_ids" {
  description = "OCIDs of the volume attachments"
  value       = { for k, v in oci_core_volume_attachment.this : k => v.id }
}

output "total_storage_gb" {
  description = "Total storage size in GBs"
  value       = sum([for v in oci_core_volume.this : v.size_in_gbs])
}
