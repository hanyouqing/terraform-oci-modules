output "cluster_id" {
  description = "OCID of the OpenSearch cluster."
  value       = module.opensearch.cluster_id
}

output "fqdn" {
  description = "API hostname of the OpenSearch cluster."
  value       = module.opensearch.fqdn
}
