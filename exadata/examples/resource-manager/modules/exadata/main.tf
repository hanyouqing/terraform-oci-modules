resource "oci_database_cloud_exadata_infrastructure" "this" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name
  shape               = var.shape
  compute_count       = var.compute_count
  storage_count       = var.storage_count

  dynamic "customer_contacts" {
    for_each = var.customer_contact_emails
    content {
      email = customer_contacts.value
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_database_cloud_vm_cluster" "this" {
  count = var.vm_cluster == null ? 0 : 1

  compartment_id                  = var.compartment_id
  cloud_exadata_infrastructure_id = oci_database_cloud_exadata_infrastructure.this.id
  display_name                    = var.vm_cluster.display_name
  hostname                        = var.vm_cluster.hostname
  cpu_core_count                  = var.vm_cluster.cpu_core_count
  gi_version                      = var.vm_cluster.gi_version
  subnet_id                       = var.vm_cluster.subnet_id
  backup_subnet_id                = var.vm_cluster.backup_subnet_id
  ssh_public_keys                 = var.vm_cluster.ssh_public_keys
  license_model                   = var.vm_cluster.license_model
  nsg_ids                         = var.vm_cluster.nsg_ids
  backup_network_nsg_ids          = var.vm_cluster.backup_network_nsg_ids
  scan_listener_port_tcp          = 1521
  scan_listener_port_tcp_ssl      = 2484

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/exadata"
    Project     = var.project
    Environment = var.environment
  }
}
