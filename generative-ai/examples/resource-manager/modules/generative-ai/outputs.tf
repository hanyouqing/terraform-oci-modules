output "dedicated_ai_cluster_id" {
  description = "OCID of the dedicated AI cluster."
  value       = oci_generative_ai_dedicated_ai_cluster.this.id
}

output "state" {
  description = "Lifecycle state of the dedicated AI cluster."
  value       = oci_generative_ai_dedicated_ai_cluster.this.state
}

output "capacity_reservation_id" {
  description = "Capacity reservation attached to the dedicated AI cluster, when one was set."
  value       = oci_generative_ai_dedicated_ai_cluster.this.capacity_reservation_id
}
