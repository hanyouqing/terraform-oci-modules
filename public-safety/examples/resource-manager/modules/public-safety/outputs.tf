output "instance_id" {
  description = "OCID of the Public Safety instance."
  value       = oci_pss_instance.this.id
}

output "service_endpoint" {
  description = "API endpoint of the Public Safety instance."
  value       = oci_pss_instance.this.service_endpoint
}

output "ui_endpoint" {
  description = "Console endpoint of the Public Safety instance."
  value       = oci_pss_instance.this.ui_endpoint
}

output "state" {
  description = "Lifecycle state of the Public Safety instance."
  value       = oci_pss_instance.this.state
}
