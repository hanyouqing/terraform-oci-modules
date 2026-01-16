output "alarm_ids" {
  description = "OCIDs of the monitoring alarms"
  value       = { for k, v in oci_monitoring_alarm.this : k => v.id }
}
