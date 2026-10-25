output "network_load_balancer_id" {
  description = "The OCID of the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_id
}

output "network_load_balancer_ip_address" {
  description = "The primary IP address of the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_ip_address
}

output "reminders" {
  description = "Helpful reminders and next steps."
  value       = module.network_load_balancer.zzz_reminders
}
