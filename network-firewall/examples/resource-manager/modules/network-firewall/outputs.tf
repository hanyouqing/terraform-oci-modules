output "network_firewall_id" {
  description = "OCID of the Network Firewall."
  value       = oci_network_firewall_network_firewall.this.id
}

output "network_firewall_policy_id" {
  description = "OCID of the Network Firewall policy."
  value       = oci_network_firewall_network_firewall_policy.this.id
}

output "ipv4address" {
  description = "IPv4 address of the firewall."
  value       = oci_network_firewall_network_firewall.this.ipv4address
}
