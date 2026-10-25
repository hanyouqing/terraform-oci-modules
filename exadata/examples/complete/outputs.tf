
output "infrastructure_id" {
  description = "OCID of the Cloud Exadata infrastructure."
  value       = module.exadata.infrastructure_id
}

output "vm_cluster_id" {
  description = "OCID of the VM cluster."
  value       = module.exadata.vm_cluster_id
}
