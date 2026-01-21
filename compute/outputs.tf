output "instance_ids" {
  description = "OCIDs of the compute instances"
  value       = oci_core_instance.this[*].id
}

output "instance_display_names" {
  description = "Display names of the compute instances"
  value       = oci_core_instance.this[*].display_name
}

output "instance_private_ips" {
  description = "Private IP addresses of the compute instances"
  value       = oci_core_instance.this[*].private_ip
}

output "instance_public_ips" {
  description = "Public IP addresses of the compute instances"
  value       = oci_core_instance.this[*].public_ip
}

output "instance_availability_domains" {
  description = "Availability domains of the compute instances"
  value       = oci_core_instance.this[*].availability_domain
}

output "boot_volume_ids" {
  description = "OCIDs of the boot volumes"
  value       = var.create_boot_volume ? oci_core_volume.boot[*].id : []
}

output "block_volume_ids" {
  description = "OCIDs of the block volumes"
  value       = { for k, v in oci_core_volume.block : k => v.id }
}

output "block_volume_attachment_ids" {
  description = "OCIDs of the block volume attachments"
  value       = { for k, v in oci_core_volume_attachment.block : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for Compute module"
  value = {
    next_steps = [
      "SSH into instances using: ssh -i ~/.ssh/id_rsa opc@${length(oci_core_instance.this) > 0 && oci_core_instance.this[0].public_ip != null ? oci_core_instance.this[0].public_ip : "PRIVATE_IP_ONLY"}",
      "Verify instances are running: oci compute instance get --instance-id ${length(oci_core_instance.this) > 0 ? oci_core_instance.this[0].id : "N/A"}",
      "Check boot volume status and ensure it's attached correctly",
      "Verify block volumes are attached if configured",
      "Review security groups and network security rules"
    ]
    verification = [
      "List instances: oci compute instance list --compartment-id ${var.compartment_id}",
      "Check instance state: oci compute instance get --instance-id ${length(oci_core_instance.this) > 0 ? oci_core_instance.this[0].id : "N/A"}",
      "View console connection: oci compute instance console-connection create --instance-id ${length(oci_core_instance.this) > 0 ? oci_core_instance.this[0].id : "N/A"}"
    ]
    security_notes = [
      "Ensure SSH keys are properly configured and secured",
      "Use Network Security Groups for additional security",
      "Consider disabling public IP if not needed",
      "Review and restrict security list rules",
      "Keep OS and software up to date"
    ]
    cost_optimization = [
      "Always Free tier: 2x VM.Standard.E2.1.Micro or 4 OCPUs VM.Standard.A1.Flex",
      "Stop instances when not in use to save costs",
      "Right-size block volumes to match actual needs",
      "Use lower VPU settings for non-performance-critical workloads"
    ]
    important_resources = {
      instance_count     = length(oci_core_instance.this)
      shape              = length(oci_core_instance.this) > 0 ? oci_core_instance.this[0].shape : "N/A"
      public_ips         = [for inst in oci_core_instance.this : inst.public_ip if inst.public_ip != null]
      private_ips        = [for inst in oci_core_instance.this : inst.private_ip]
      block_volume_count = length(oci_core_volume.block)
      total_storage_gb   = sum([for v in oci_core_volume.block : v.size_in_gbs])
    }
    access_info = length(oci_core_instance.this) > 0 ? {
      ssh_command = "ssh -i ~/.ssh/id_rsa opc@${oci_core_instance.this[0].public_ip != null ? oci_core_instance.this[0].public_ip : oci_core_instance.this[0].private_ip}"
      instance_id = oci_core_instance.this[0].id
    } : null
  }
}
