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
