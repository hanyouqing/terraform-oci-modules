output "file_system_id" {
  description = "OCID of the file system."
  value       = oci_file_storage_file_system.this.id
}

output "mount_target_id" {
  description = "OCID of the mount target."
  value       = oci_file_storage_mount_target.this.id
}

output "export_id" {
  description = "OCID of the export."
  value       = oci_file_storage_export.this.id
}

output "export_set_id" {
  description = "OCID of the export set created with the mount target."
  value       = oci_file_storage_mount_target.this.export_set_id
}
