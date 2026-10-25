
output "cluster_id" {
  description = "OCID of the OKE cluster."
  value       = module.oke.cluster_id
}

output "node_pool_ids" {
  description = "Node pool OCIDs keyed by name."
  value       = module.oke.node_pool_ids
}
