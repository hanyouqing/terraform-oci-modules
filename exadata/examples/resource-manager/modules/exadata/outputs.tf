output "infrastructure_id" {
  description = "OCID of the Cloud Exadata infrastructure."
  value       = oci_database_cloud_exadata_infrastructure.this.id
}

output "vm_cluster_id" {
  description = "OCID of the VM cluster. Null when vm_cluster is not set."
  value       = try(oci_database_cloud_vm_cluster.this[0].id, null)
}
