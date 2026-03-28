output "cpe_ids" {
  description = "OCIDs of the Customer-Premises Equipment objects"
  value       = { for k, v in oci_core_cpe.this : k => v.id }
}

output "cpe_ip_addresses" {
  description = "IP addresses of the CPE objects"
  value       = { for k, v in oci_core_cpe.this : k => v.ip_address }
}

output "ipsec_connection_ids" {
  description = "OCIDs of the IPSec connections"
  value       = { for k, v in oci_core_ipsec.this : k => v.id }
}

output "ipsec_connection_states" {
  description = "States of the IPSec connections"
  value       = { for k, v in oci_core_ipsec.this : k => v.state }
}

output "tunnel_details" {
  description = "Tunnel details for each IPSec connection (2 tunnels per connection)"
  value = {
    for k, v in data.oci_core_ipsec_connection_tunnels.this : k => [
      for tunnel in v.ip_sec_connection_tunnels : {
        id         = tunnel.id
        vpn_ip     = tunnel.vpn_ip
        status     = tunnel.status
        ike_version = tunnel.ike_version
        routing    = tunnel.routing
        state      = tunnel.state
      }
    ]
  }
}

output "tunnel_vpn_ips" {
  description = "Oracle VPN endpoint IPs for each IPSec connection (for on-premises CPE configuration)"
  value = {
    for k, v in data.oci_core_ipsec_connection_tunnels.this : k => [
      for tunnel in v.ip_sec_connection_tunnels : tunnel.vpn_ip
    ]
  }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Site-to-Site VPN module"
  value = {
    next_steps = [
      "Configure your on-premises CPE device with the Oracle VPN endpoint IPs and shared secrets",
      "Get tunnel shared secrets: oci network ip-sec-tunnel get --ipsc-id <ipsec_id> --tunnel-id <tunnel_id>",
      "Verify tunnel status is UP on both Oracle and on-premises sides",
      "Add DRG route rules in VCN to route traffic through the VPN",
      "Configure BGP or verify static routes for production workloads",
      "Set up monitoring alarms for tunnel status changes"
    ]
    verification = [
      "List IPSec connections: oci network ip-sec-connection list --compartment-id ${var.compartment_id}",
      "Get connection details: oci network ip-sec-connection get --ipsc-id ${length(oci_core_ipsec.this) > 0 ? values(oci_core_ipsec.this)[0].id : "N/A"}",
      "List tunnels: oci network ip-sec-tunnel list --ipsc-id ${length(oci_core_ipsec.this) > 0 ? values(oci_core_ipsec.this)[0].id : "N/A"}",
      "Check tunnel status: oci network ip-sec-tunnel get --ipsc-id <ipsec_id> --tunnel-id <tunnel_id>"
    ]
    security_notes = [
      "Use IKEv2 for stronger security (configure via tunnel management)",
      "Rotate shared secrets regularly",
      "Use BGP routing for automatic failover between tunnels",
      "Restrict DRG route table to only necessary on-premises CIDRs",
      "Enable VCN flow logs to monitor VPN traffic patterns"
    ]
    cost_optimization = [
      "Always Free: 50 IPSec connections per tenancy (no charge)",
      "Each connection provides 2 redundant tunnels at no extra cost",
      "Data transfer through VPN is charged at standard OCI rates",
      "Use VPN for dev/test; consider FastConnect for production high-bandwidth",
      "Monitor tunnel utilization to right-size bandwidth needs"
    ]
    important_resources = {
      cpe_count    = length(oci_core_cpe.this)
      ipsec_count  = length(oci_core_ipsec.this)
      tunnel_count = length(oci_core_ipsec.this) * 2
    }
  }
}
