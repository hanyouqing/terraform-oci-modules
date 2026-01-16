output "instance_ids" {
  description = "Instance IDs"
  value       = module.compute.instance_ids
}

output "instance_display_names" {
  description = "Instance display names"
  value       = module.compute.instance_display_names
}

output "instance_public_ips" {
  description = "Instance public IPs"
  value       = module.compute.instance_public_ips
}

output "instance_private_ips" {
  description = "Instance private IPs"
  value       = module.compute.instance_private_ips
}

output "instance_availability_domains" {
  description = "Instance availability domains"
  value       = module.compute.instance_availability_domains
}

output "boot_volume_ids" {
  description = "Boot volume IDs"
  value       = module.compute.boot_volume_ids
}

output "block_volume_ids" {
  description = "Block volume IDs"
  value       = module.compute.block_volume_ids
}
