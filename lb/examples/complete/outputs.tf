output "load_balancer_id" {
  description = "Load balancer ID"
  value       = module.load_balancer.load_balancer_id
}

output "load_balancer_ip_address" {
  description = "Load balancer IP address"
  value       = module.load_balancer.load_balancer_ip_address
}

output "load_balancer_ip_addresses" {
  description = "Load balancer IP addresses"
  value       = module.load_balancer.load_balancer_ip_addresses
}

output "backend_set_names" {
  description = "Backend set names"
  value       = module.load_balancer.backend_set_names
}

output "listener_names" {
  description = "Listener names"
  value       = module.load_balancer.listener_names
}
