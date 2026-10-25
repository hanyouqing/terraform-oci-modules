
output "file_system_id" {
  description = "OCID of the file system."
  value       = module.file_storage.file_system_id
}

output "mount_target_id" {
  description = "OCID of the mount target."
  value       = module.file_storage.mount_target_id
}
