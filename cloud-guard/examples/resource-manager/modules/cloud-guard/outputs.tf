output "reporting_region" {
  description = "Region where Cloud Guard reports findings."
  value       = oci_cloud_guard_cloud_guard_configuration.this.reporting_region
}

output "status" {
  description = "Cloud Guard status for the tenancy."
  value       = oci_cloud_guard_cloud_guard_configuration.this.status
}

output "target_ids" {
  description = "OCIDs of Cloud Guard targets, keyed by display name."
  value       = { for name, target in oci_cloud_guard_target.this : name => target.id }
}
