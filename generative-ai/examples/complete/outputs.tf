output "dedicated_ai_cluster_id" {
  description = "OCID of the dedicated AI cluster."
  value       = module.generative_ai.dedicated_ai_cluster_id
}

output "capacity_reservation_id" {
  description = "Capacity reservation attached to the cluster."
  value       = module.generative_ai.capacity_reservation_id
}
