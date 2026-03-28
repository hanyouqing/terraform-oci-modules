output "cpe_ids" {
  description = "CPE IDs"
  value       = module.vpn.cpe_ids
}

output "ipsec_connection_ids" {
  description = "IPSec connection IDs"
  value       = module.vpn.ipsec_connection_ids
}

output "ipsec_connection_states" {
  description = "IPSec connection states"
  value       = module.vpn.ipsec_connection_states
}

output "tunnel_details" {
  description = "Tunnel details per connection"
  value       = module.vpn.tunnel_details
}

output "tunnel_vpn_ips" {
  description = "Oracle VPN endpoint IPs"
  value       = module.vpn.tunnel_vpn_ips
}
