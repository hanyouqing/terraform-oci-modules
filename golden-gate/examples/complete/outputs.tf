output "connection_id" {
  description = "OCID of the GoldenGate connection."
  value       = module.golden_gate.connection_id
}

output "deployment_id" {
  description = "OCID of the GoldenGate deployment. Null when deployment is not set."
  value       = module.golden_gate.deployment_id
}
