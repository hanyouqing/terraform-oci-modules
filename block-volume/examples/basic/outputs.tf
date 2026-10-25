output "volume_ids" {
  description = "Volume IDs"
  value       = module.block_storage.volume_ids
}

output "total_storage_gb" {
  description = "Total storage in GB"
  value       = module.block_storage.total_storage_gb
}
