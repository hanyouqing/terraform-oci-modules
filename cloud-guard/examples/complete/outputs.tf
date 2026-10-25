
output "target_ids" {
  description = "Cloud Guard target OCIDs keyed by name."
  value       = module.cloud_guard.target_ids
}
