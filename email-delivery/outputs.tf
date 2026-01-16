output "sender_ids" {
  description = "OCIDs of the email senders"
  value       = { for k, v in oci_email_sender.this : k => v.id }
}

output "suppression_ids" {
  description = "OCIDs of the email suppressions"
  value       = { for k, v in oci_email_suppression.this : k => v.id }
}
