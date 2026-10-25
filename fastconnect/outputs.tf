output "virtual_circuit_id" {
  description = "OCID of the FastConnect virtual circuit."
  value       = oci_core_virtual_circuit.this.id
}

output "virtual_circuit_state" {
  description = "Lifecycle state of the virtual circuit."
  value       = oci_core_virtual_circuit.this.state
}
