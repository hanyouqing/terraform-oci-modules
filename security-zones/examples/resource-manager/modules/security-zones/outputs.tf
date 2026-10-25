output "security_zone_id" {
  description = "OCID of the Security Zone."
  value       = oci_cloud_guard_security_zone.this.id
}

output "security_zone_recipe_id" {
  description = "OCID of the recipe attached to the zone."
  value       = oci_cloud_guard_security_zone.this.security_zone_recipe_id
}

output "security_zone_target_id" {
  description = "OCID of the Cloud Guard target created with the zone."
  value       = oci_cloud_guard_security_zone.this.security_zone_target_id
}
