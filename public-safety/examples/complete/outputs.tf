output "instance_id" {
  description = "OCID of the Public Safety instance."
  value       = module.public_safety.instance_id
}

output "ui_endpoint" {
  description = "Console endpoint of the Public Safety instance."
  value       = module.public_safety.ui_endpoint
}

output "state" {
  description = "Lifecycle state of the Public Safety instance."
  value       = module.public_safety.state
}
