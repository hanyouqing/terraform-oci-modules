# -----------------------------------------------------------------------------
# Network Load Balancer Outputs
# -----------------------------------------------------------------------------

output "network_load_balancer_id" {
  description = "The OCID of the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.this.id
}

output "network_load_balancer_ip_addresses" {
  description = "The IP addresses associated with the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.this.ip_addresses
}

output "network_load_balancer_ip_address" {
  description = "The primary IP address of the Network Load Balancer."
  value       = try(oci_network_load_balancer_network_load_balancer.this.ip_addresses[0].ip_address, null)
}

output "network_load_balancer_state" {
  description = "The current lifecycle state of the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.this.state
}

output "network_load_balancer_time_created" {
  description = "The date and time the Network Load Balancer was created."
  value       = oci_network_load_balancer_network_load_balancer.this.time_created
}

# -----------------------------------------------------------------------------
# Backend Set Outputs
# -----------------------------------------------------------------------------

output "backend_set_names" {
  description = "List of backend set names."
  value       = keys(oci_network_load_balancer_backend_set.this)
}

output "backend_set_ids" {
  description = "Map of backend set names to their composite IDs."
  value       = { for k, v in oci_network_load_balancer_backend_set.this : k => v.id }
}

# -----------------------------------------------------------------------------
# Listener Outputs
# -----------------------------------------------------------------------------

output "listener_names" {
  description = "List of listener names."
  value       = keys(oci_network_load_balancer_listener.this)
}

# -----------------------------------------------------------------------------
# Backend Outputs
# -----------------------------------------------------------------------------

output "backend_ids" {
  description = "Map of backend names to their composite IDs."
  value       = { for k, v in oci_network_load_balancer_backend.this : k => v.id }
}

# -----------------------------------------------------------------------------
# Reminders
# -----------------------------------------------------------------------------

output "zzz_reminders" {
  description = "Helpful reminders and next steps for Network Load Balancer management."
  value = {
    next_steps = [
      "1. Add backend servers (compute instances) to backend sets",
      "2. Configure Network Security Groups to allow traffic on listener ports",
      "3. Set up health check endpoints on backend servers",
      "4. Verify NLB health status in the OCI Console",
    ]
    verification = [
      "oci nlb network-load-balancer get --network-load-balancer-id <NLB_OCID>",
      "oci nlb backend-set list --network-load-balancer-id <NLB_OCID>",
      "oci nlb backend-health get --network-load-balancer-id <NLB_OCID> --backend-set-name <NAME> --backend-name <NAME>",
      "oci nlb work-request list --compartment-id <COMPARTMENT_OCID>",
    ]
    security_notes = [
      "NLB operates at Layer 4 — no SSL termination (use backends for TLS)",
      "Use Network Security Groups to restrict traffic to known sources",
      "Enable is_preserve_source_destination for transparent source IP visibility",
      "Use private NLB (is_private=true) for internal traffic between services",
    ]
    cost_optimization = [
      "Always Free: 1 NLB instance per tenancy at no cost",
      "NLB has no bandwidth shape — it scales automatically",
      "No additional charges for backend sets, backends, or listeners",
      "Use TCP health checks instead of HTTP to reduce backend load",
    ]
    important_resources = {
      nlb_id     = oci_network_load_balancer_network_load_balancer.this.id
      nlb_ip     = try(oci_network_load_balancer_network_load_balancer.this.ip_addresses[0].ip_address, "pending")
      nlb_state  = oci_network_load_balancer_network_load_balancer.this.state
      is_private = var.is_private
    }
    access_info = {
      test_tcp = "nc -zv <NLB_IP> <PORT>"
      test_udp = "nc -zuv <NLB_IP> <PORT>"
    }
  }
}
