output "instance_ids" {
  description = "Instance OCIDs"
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs"
  value       = module.compute.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IPs"
  value       = module.compute.instance_private_ips
}
