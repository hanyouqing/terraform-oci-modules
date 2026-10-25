output "connection_id" {
  description = "OCID of the GoldenGate connection."
  value       = oci_golden_gate_connection.this.id
}

output "deployment_id" {
  description = "OCID of the GoldenGate deployment. Null when deployment is not set."
  value       = try(oci_golden_gate_deployment.this[0].id, null)
}
