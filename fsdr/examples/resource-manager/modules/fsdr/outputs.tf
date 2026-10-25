output "dr_protection_group_id" {
  description = "OCID of the DR protection group."
  value       = oci_disaster_recovery_dr_protection_group.this.id
}

output "role" {
  description = "Role of the protection group when associated."
  value       = try(oci_disaster_recovery_dr_protection_group.this.role, null)
}
