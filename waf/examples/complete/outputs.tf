output "policy_id" {
  description = "OCID of the WAF policy."
  value       = module.waf.policy_id
}

output "firewall_id" {
  description = "OCID of the WAF firewall."
  value       = module.waf.firewall_id
}
