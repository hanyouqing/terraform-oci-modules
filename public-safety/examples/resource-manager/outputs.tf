output "instance_id" {
  description = "OCID of the Public Safety instance."
  value       = module.public_safety.instance_id
}

output "service_endpoint" {
  description = "API endpoint of the Public Safety instance."
  value       = module.public_safety.service_endpoint
}
