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

output "zzz_reminders" {
  description = "Important reminders and next steps for Load Balancer module"
  value = {
    next_steps = [
      "Verify backend servers are healthy and responding",
      "Test load balancer endpoints and verify traffic distribution",
      "Configure SSL/TLS certificates for HTTPS listeners",
      "Review and adjust health check settings",
      "Monitor load balancer metrics and performance"
    ]
    verification = [
      "List load balancers: oci lb load-balancer list --compartment-id ${var.compartment_id}",
      "Check load balancer state: oci lb load-balancer get --load-balancer-id ${oci_load_balancer_load_balancer.this.id}",
      "View backend sets: oci lb backend-set list --load-balancer-id ${oci_load_balancer_load_balancer.this.id}",
      "Check backend health: oci lb backend-health get --load-balancer-id ${oci_load_balancer_load_balancer.this.id} --backend-set-name <name>"
    ]
    security_notes = [
      "Use HTTPS listeners for secure traffic",
      "Configure SSL/TLS certificates (BYOC or OCI managed)",
      "Use Network Security Groups for additional security",
      "Restrict access to load balancer management endpoints",
      "Enable WAF if available for additional protection"
    ]
    cost_optimization = [
      "Always Free tier: 1 flexible load balancer, 10 Mbps",
      "Right-size bandwidth to match actual traffic needs",
      "Use flexible shape for variable traffic patterns",
      "Monitor traffic and adjust bandwidth as needed",
      "Bring Your Own Certificate (BYOC) to avoid certificate fees"
    ]
    important_resources = {
      load_balancer_id  = oci_load_balancer_load_balancer.this.id
      ip_address        = length(oci_load_balancer_load_balancer.this.ip_address_details) > 0 ? oci_load_balancer_load_balancer.this.ip_address_details[0].ip_address : null
      backend_set_count = length(var.backend_sets)
      listener_count    = length(var.listeners)
      shape             = oci_load_balancer_load_balancer.this.shape
    }
    access_info = {
      load_balancer_url = length(oci_load_balancer_load_balancer.this.ip_address_details) > 0 ? "http://${oci_load_balancer_load_balancer.this.ip_address_details[0].ip_address}" : "N/A"
      test_command      = length(oci_load_balancer_load_balancer.this.ip_address_details) > 0 ? "curl http://${oci_load_balancer_load_balancer.this.ip_address_details[0].ip_address}" : "N/A"
    }
  }
}
