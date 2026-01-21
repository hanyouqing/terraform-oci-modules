output "bastion_id" {
  description = "OCID of the bastion"
  value       = oci_bastion_bastion.this.id
}

output "bastion_name" {
  description = "Name of the bastion"
  value       = oci_bastion_bastion.this.name
}

output "session_ids" {
  description = "OCIDs of the bastion sessions"
  value       = { for k, v in oci_bastion_session.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Bastion module"
  value = {
    next_steps = [
      "Create bastion sessions to connect to private resources",
      "Test SSH connections through bastion",
      "Review and restrict client CIDR block allow list",
      "Monitor session usage and duration",
      "Set up session timeouts appropriately"
    ]
    verification = [
      "List bastions: oci bastion bastion list --compartment-id ${var.compartment_id}",
      "Check bastion state: oci bastion bastion get --bastion-id ${oci_bastion_bastion.this.id}",
      "List sessions: oci bastion session list --bastion-id ${oci_bastion_bastion.this.id}",
      "Get session details: oci bastion session get --session-id ${length(oci_bastion_session.this) > 0 ? values(oci_bastion_session.this)[0].id : "N/A"}"
    ]
    security_notes = [
      "Bastion service is completely free for all account types",
      "Restrict client CIDR block allow list to trusted IPs",
      "Use strong SSH keys for session authentication",
      "Monitor session activity for security",
      "Set appropriate session TTL to limit exposure"
    ]
    cost_optimization = [
      "Bastion service is free - no cost optimization needed",
      "Reuse sessions when possible to avoid creation overhead",
      "Monitor session usage to ensure compliance with limits"
    ]
    important_resources = {
      bastion_id    = oci_bastion_bastion.this.id
      bastion_name  = oci_bastion_bastion.this.name
      session_count = length(oci_bastion_session.this)
      bastion_type  = oci_bastion_bastion.this.bastion_type
    }
    usage_tips = [
      "Use OCI CLI or Console to create and manage sessions",
      "Sessions are limited to 3 hours duration",
      "Standard bastion supports up to 50 concurrent sessions",
      "Use SSH port forwarding for secure access to private resources"
    ]
  }
}
