output "child_tenancy_id" {
  description = "OCID of the child tenancy work request result."
  value       = oci_tenantmanagercontrolplane_child_tenancy.this.id
}
