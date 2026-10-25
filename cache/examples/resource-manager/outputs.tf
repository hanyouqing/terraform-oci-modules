output "cluster_id" {
  description = "OCID of the OCI Cache cluster."
  value       = module.cache.cluster_id
}

output "primary_fqdn" {
  description = "Primary endpoint FQDN."
  value       = module.cache.primary_fqdn
}
