output "load_balancer_id" {
  description = "OCID of the load balancer"
  value       = oci_load_balancer_load_balancer.this.id
}

output "load_balancer_ip_addresses" {
  description = "IP addresses of the load balancer"
  value       = oci_load_balancer_load_balancer.this.ip_address_details
}

output "load_balancer_ip_address" {
  description = "Primary IP address of the load balancer"
  value       = length(oci_load_balancer_load_balancer.this.ip_address_details) > 0 ? oci_load_balancer_load_balancer.this.ip_address_details[0].ip_address : null
}

output "backend_set_names" {
  description = "Names of the backend sets"
  value       = keys(var.backend_sets)
}

output "listener_names" {
  description = "Names of the listeners"
  value       = keys(var.listeners)
}
