output "policy_id" {
  description = "OCID of the WAF policy."
  value       = oci_waf_web_app_firewall_policy.this.id
}

output "firewall_id" {
  description = "OCID of the WAF firewall. Null when load_balancer_id is not set."
  value       = try(oci_waf_web_app_firewall.this[0].id, null)
}
