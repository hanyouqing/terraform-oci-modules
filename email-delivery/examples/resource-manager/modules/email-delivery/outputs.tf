output "sender_ids" {
  description = "OCIDs of the email senders"
  value       = { for k, v in oci_email_sender.this : k => v.id }
}

output "suppression_ids" {
  description = "OCIDs of the email suppressions"
  value       = { for k, v in oci_email_suppression.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Email Delivery module"
  value = {
    next_steps = [
      "Verify sender email addresses are verified",
      "Test email delivery with sample emails",
      "Configure SPF and DKIM records for domain authentication",
      "Review and manage email suppressions",
      "Monitor email delivery rates and bounces"
    ]
    verification = [
      "List senders: oci email sender list --compartment-id ${var.compartment_id}",
      "Check sender status: oci email sender get --sender-id ${length(oci_email_sender.this) > 0 ? values(oci_email_sender.this)[0].id : "N/A"}",
      "List suppressions: oci email suppression list --compartment-id ${var.compartment_id}",
      "Test email: Use OCI SDK or API to send test email"
    ]
    security_notes = [
      "Verify sender email addresses to prevent spoofing",
      "Use SPF, DKIM, and DMARC for email authentication",
      "Monitor for email abuse and spam complaints",
      "Review suppressions regularly to maintain list hygiene",
      "Use IAM policies to restrict email sending"
    ]
    cost_optimization = [
      "Always Free tier: 3,000 emails per month",
      "Optimize email frequency to reduce volume",
      "Use email suppressions to avoid sending to invalid addresses",
      "Monitor email usage to stay within Always Free tier",
      "Batch emails when possible to reduce per-email overhead"
    ]
    important_resources = {
      sender_count      = length(oci_email_sender.this)
      suppression_count = length(oci_email_suppression.this)
    }
    usage_tips = [
      "Use transactional email best practices",
      "Monitor bounce rates and handle suppressions",
      "Configure domain authentication for better deliverability",
      "Test email delivery regularly",
      "Use email templates for consistent messaging"
    ]
  }
}
