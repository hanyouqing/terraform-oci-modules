output "cluster_id" {
  description = "OCID of the OKE cluster."
  value       = oci_containerengine_cluster.this.id
}

output "cluster_kubernetes_version" {
  description = "Kubernetes version of the cluster."
  value       = oci_containerengine_cluster.this.kubernetes_version
}

output "node_pool_ids" {
  description = "OCIDs of the node pools, keyed by pool name."
  value       = { for name, pool in oci_containerengine_node_pool.this : name => pool.id }
}
