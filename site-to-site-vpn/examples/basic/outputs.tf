output "cpe_ids" {
  description = "CPE IDs"
  value       = module.vpn.cpe_ids
}

output "ipsec_connection_ids" {
  description = "IPSec connection IDs"
  value       = module.vpn.ipsec_connection_ids
}

output "tunnel_vpn_ips" {
  description = "Oracle VPN endpoint IPs (configure these on your CPE device)"
  value       = module.vpn.tunnel_vpn_ips
}
