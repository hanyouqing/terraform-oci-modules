output "log_group_ids" {
  description = "OCIDs of the log groups"
  value       = { for k, v in oci_logging_log_group.this : k => v.id }
}

output "log_ids" {
  description = "OCIDs of the logs"
  value       = { for k, v in oci_logging_log.this : k => v.id }
}
