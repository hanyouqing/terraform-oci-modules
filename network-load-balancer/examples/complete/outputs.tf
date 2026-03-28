output "network_load_balancer_id" {
  description = "The OCID of the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_id
}

output "network_load_balancer_ip_addresses" {
  description = "The IP addresses associated with the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_ip_addresses
}

output "network_load_balancer_ip_address" {
  description = "The primary IP address of the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_ip_address
}

output "network_load_balancer_state" {
  description = "The current lifecycle state of the Network Load Balancer."
  value       = module.network_load_balancer.network_load_balancer_state
}

output "backend_set_names" {
  description = "List of backend set names."
  value       = module.network_load_balancer.backend_set_names
}

output "listener_names" {
  description = "List of listener names."
  value       = module.network_load_balancer.listener_names
}

output "backend_ids" {
  description = "Map of backend names to their composite IDs."
  value       = module.network_load_balancer.backend_ids
}

output "reminders" {
  description = "Helpful reminders and next steps."
  value       = module.network_load_balancer.zzz_reminders
}
