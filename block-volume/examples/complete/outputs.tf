output "volume_ids" {
  description = "Volume IDs"
  value       = module.block_storage.volume_ids
}

output "volume_sizes" {
  description = "Volume sizes"
  value       = module.block_storage.volume_sizes
}

output "backup_ids" {
  description = "Backup IDs"
  value       = module.block_storage.backup_ids
}

output "backup_policy_ids" {
  description = "Backup policy IDs"
  value       = module.block_storage.backup_policy_ids
}

output "attachment_ids" {
  description = "Attachment IDs"
  value       = module.block_storage.attachment_ids
}

output "total_storage_gb" {
  description = "Total storage in GB"
  value       = module.block_storage.total_storage_gb
}
