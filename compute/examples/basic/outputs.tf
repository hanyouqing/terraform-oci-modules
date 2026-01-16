output "instance_ids" {
  description = "Instance IDs"
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Instance public IPs"
  value       = module.compute.instance_public_ips
}

output "instance_private_ips" {
  description = "Instance private IPs"
  value       = module.compute.instance_private_ips
}
