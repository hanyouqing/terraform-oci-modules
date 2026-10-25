output "volume_ids" {
  description = "OCIDs of the block volumes"
  value       = { for k, v in oci_core_volume.this : k => v.id }
}

output "volume_display_names" {
  description = "Display names of the block volumes"
  value       = { for k, v in oci_core_volume.this : k => v.display_name }
}

output "volume_sizes" {
  description = "Sizes of the block volumes in GBs"
  value       = { for k, v in oci_core_volume.this : k => v.size_in_gbs }
}

output "backup_ids" {
  description = "OCIDs of the volume backups"
  value       = { for k, v in oci_core_volume_backup.this : k => v.id }
}

output "backup_policy_ids" {
  description = "OCIDs of the backup policies"
  value       = { for k, v in oci_core_volume_backup_policy.this : k => v.id }
}

output "attachment_ids" {
  description = "OCIDs of the volume attachments"
  value       = { for k, v in oci_core_volume_attachment.this : k => v.id }
}

output "total_storage_gb" {
  description = "Total storage size in GBs"
  value       = sum([for v in oci_core_volume.this : v.size_in_gbs])
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Block Storage module"
  value = {
    next_steps = [
      "Verify volumes are attached to compute instances correctly",
      "Check volume performance (VPU settings) match workload requirements",
      "Review backup policies and ensure backups are scheduled",
      "Monitor storage usage to stay within Always Free tier (200 GB total)",
      "Test volume attachment and detachment procedures"
    ]
    verification = [
      "List volumes: oci bv volume list --compartment-id ${var.compartment_id}",
      "Check volume state: oci bv volume get --volume-id ${length(oci_core_volume.this) > 0 ? values(oci_core_volume.this)[0].id : "N/A"}",
      "List backups: oci bv backup list --compartment-id ${var.compartment_id}",
      "Verify attachments: oci compute volume-attachment list --compartment-id ${var.compartment_id}"
    ]
    security_notes = [
      "Ensure volumes are encrypted at rest (default in OCI)",
      "Review backup retention policies for compliance",
      "Secure backup access and ensure proper IAM policies",
      "Consider using volume groups for coordinated backups"
    ]
    cost_optimization = [
      "Always Free tier: 200 GB total (boot + block volumes)",
      "Use Standard performance (10 VPUs/GB) for non-critical workloads",
      "Right-size volumes to match actual storage needs",
      "Optimize backup frequency to balance recovery needs with costs",
      "Enable auto-tune for automatic performance optimization"
    ]
    important_resources = {
      volume_count     = length(oci_core_volume.this)
      total_storage_gb = sum([for v in oci_core_volume.this : v.size_in_gbs])
      backup_count     = length(oci_core_volume_backup.this)
      attachment_count = length(oci_core_volume_attachment.this)
      within_free_tier = sum([for v in oci_core_volume.this : v.size_in_gbs]) <= 200
    }
    usage_tips = [
      "Mount volumes on Linux: sudo mkfs.ext4 /dev/oracleoci/oraclevdb && sudo mount /dev/oracleoci/oraclevdb /mnt",
      "Check volume status: lsblk or df -h",
      "Backup before resizing volumes",
      "Use volume groups for coordinated operations"
    ]
  }
}
