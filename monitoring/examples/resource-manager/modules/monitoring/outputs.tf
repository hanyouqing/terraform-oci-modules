output "alarm_ids" {
  description = "OCIDs of the monitoring alarms"
  value       = { for k, v in oci_monitoring_alarm.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Monitoring module"
  value = {
    next_steps = [
      "Verify alarms are triggering correctly with test conditions",
      "Configure notification destinations (topics, emails, etc.)",
      "Review alarm thresholds and adjust as needed",
      "Set up dashboards to visualize metrics",
      "Test alarm notifications to ensure they work"
    ]
    verification = [
      "List alarms: oci monitoring alarm list --compartment-id ${var.compartment_id}",
      "Check alarm state: oci monitoring alarm get --alarm-id ${length(oci_monitoring_alarm.this) > 0 ? values(oci_monitoring_alarm.this)[0].id : "N/A"}",
      "View alarm history: oci monitoring alarm-history get --alarm-id ${length(oci_monitoring_alarm.this) > 0 ? values(oci_monitoring_alarm.this)[0].id : "N/A"}"
    ]
    security_notes = [
      "Review alarm queries to ensure they're secure",
      "Use IAM policies to restrict alarm management",
      "Monitor alarm access and changes",
      "Use secure notification channels for sensitive alerts"
    ]
    cost_optimization = [
      "Always Free tier: 500M ingestion + 1B retrieval data points",
      "Optimize metric collection frequency to reduce data points",
      "Filter unnecessary metrics to reduce ingestion volume",
      "Use metric aggregation to reduce data point count",
      "Monitor data point usage to stay within Always Free tier"
    ]
    important_resources = {
      alarm_count = length(oci_monitoring_alarm.this)
    }
    usage_tips = [
      "Use MQL (Monitoring Query Language) for complex queries",
      "Set appropriate severity levels (CRITICAL, WARNING, INFO)",
      "Configure multiple destinations for redundancy",
      "Test alarms regularly to ensure they're working",
      "Use alarm suppression to avoid alert fatigue"
    ]
  }
}
