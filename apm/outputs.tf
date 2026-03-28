output "apm_domain_ids" {
  description = "OCIDs of the APM domains"
  value       = { for k, v in oci_apm_apm_domain.this : k => v.id }
}

output "apm_domain_data_upload_endpoints" {
  description = "Data upload endpoints for APM domains (used by agents)"
  value       = { for k, v in oci_apm_apm_domain.this : k => v.data_upload_endpoint }
  sensitive   = true
}

output "apm_domain_states" {
  description = "Lifecycle states of the APM domains"
  value       = { for k, v in oci_apm_apm_domain.this : k => v.state }
}

output "synthetics_monitor_ids" {
  description = "OCIDs of the Synthetics monitors"
  value       = { for k, v in oci_apm_synthetics_monitor.this : k => v.id }
}

output "synthetics_monitor_statuses" {
  description = "Statuses of the Synthetics monitors"
  value       = { for k, v in oci_apm_synthetics_monitor.this : k => v.status }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for APM module"
  value = {
    next_steps = [
      "Install APM agents (Java, Node.js, .NET, etc.) using the data upload endpoint",
      "Configure IAM policies: Allow group <group> to manage apm-domains in compartment <compartment>",
      "Set up alerting rules for application performance thresholds",
      "Configure Synthetics monitors to probe external and internal endpoints",
      "Review trace data in the OCI Console under Application Performance Monitoring"
    ]
    verification = [
      "List APM domains: oci apm domain list --compartment-id ${var.compartment_id}",
      "Get domain: oci apm domain get --apm-domain-id ${length(oci_apm_apm_domain.this) > 0 ? values(oci_apm_apm_domain.this)[0].id : "N/A"}",
      "List monitors: oci apm-synthetics monitor list --apm-domain-id ${length(oci_apm_apm_domain.this) > 0 ? values(oci_apm_apm_domain.this)[0].id : "N/A"}"
    ]
    security_notes = [
      "Data upload endpoints contain private keys — treat as secrets",
      "Use IAM policies to restrict who can view APM data",
      "Synthetics monitors may expose endpoint availability — use private vantage points for internal services",
      "Enable OCI Audit logging for APM operations"
    ]
    cost_optimization = [
      "Always Free: 1,000 tracing events/hour, 10 synthetic monitor runs/hour",
      "Use is_free_tier = true for development and testing domains",
      "Limit Synthetics monitor frequency to stay within free tier (10 runs/hour = 1 run per 360 seconds)",
      "Use sampling to reduce tracing event volume in production",
      "Monitor data upload usage to avoid exceeding free tier limits"
    ]
    important_resources = {
      domain_count  = length(oci_apm_apm_domain.this)
      monitor_count = length(oci_apm_synthetics_monitor.this)
      domains       = { for k, v in oci_apm_apm_domain.this : k => v.display_name }
    }
  }
}
