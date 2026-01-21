output "log_group_ids" {
  description = "OCIDs of the log groups"
  value       = { for k, v in oci_logging_log_group.this : k => v.id }
}

output "log_ids" {
  description = "OCIDs of the logs"
  value       = { for k, v in oci_logging_log.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Logging module"
  value = {
    next_steps = [
      "Configure log sources to send logs to log groups",
      "Set up log retention policies",
      "Create log searches and queries",
      "Set up log-based alerts and monitoring",
      "Review and archive old logs"
    ]
    verification = [
      "List log groups: oci logging log-group list --compartment-id ${var.compartment_id}",
      "Check log group details: oci logging log-group get --log-group-id ${length(oci_logging_log_group.this) > 0 ? values(oci_logging_log_group.this)[0].id : "N/A"}",
      "List logs: oci logging log list --log-group-id ${length(oci_logging_log_group.this) > 0 ? values(oci_logging_log_group.this)[0].id : "N/A"}",
      "Search logs: Use OCI Console or API to search log content"
    ]
    security_notes = [
      "Review log access policies and IAM permissions",
      "Enable audit logging for compliance",
      "Secure log storage and access",
      "Monitor log access for suspicious activity",
      "Use log encryption for sensitive data"
    ]
    cost_optimization = [
      "Always Free tier: Free log ingestion and storage",
      "Optimize log retention to reduce storage costs",
      "Filter unnecessary logs to reduce ingestion volume",
      "Use log aggregation to reduce storage requirements",
      "Archive old logs to cheaper storage tiers if available"
    ]
    important_resources = {
      log_group_count = length(oci_logging_log_group.this)
      log_count       = length(oci_logging_log.this)
    }
    usage_tips = [
      "Use log groups to organize logs by application or service",
      "Set appropriate retention durations based on compliance needs",
      "Use log searches to troubleshoot issues",
      "Set up log-based alerts for critical events",
      "Regularly review and clean up old logs"
    ]
  }
}
