output "load_balancer_id" {
  description = "Load balancer ID"
  value       = module.load_balancer.load_balancer_id
}

output "load_balancer_ip_address" {
  description = "Load balancer IP address"
  value       = module.load_balancer.load_balancer_ip_address
}
