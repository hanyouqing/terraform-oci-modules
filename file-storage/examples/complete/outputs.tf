
output "file_system_id" {
  description = "OCID of the file system."
  value       = module.file_storage.file_system_id
}

output "export_id" {
  description = "OCID of the export."
  value       = module.file_storage.export_id
}
